Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1F0Qmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1F0Qmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:42:36 -0400
Message-ID: <4E08B2EB.7020306@redhat.com>
Date: Mon, 27 Jun 2011 13:42:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl  doesn't
 exist
References: <4E0519B7.3000304@redhat.com> <201106271656.04612.hverkuil@xs4all.nl> <4E08A2E6.6020902@redhat.com> <201106271814.36251.arnd@arndb.de>
In-Reply-To: <201106271814.36251.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-06-2011 13:14, Arnd Bergmann escreveu:
> On Monday 27 June 2011, Mauro Carvalho Chehab wrote:
>>> The point is that the spec can easily be improved to make such 'NOP' operations
>>> explicit, or to require that if a capability is present, then the corresponding
>>> ioctl(s) must also be present. Things like that are easy to verify as well with
>>> v4l2-compliance.
>>
>> We currently have more than 64 ioctl's. Adding a capability bit for each doesn't
>> seem the right thing to do. Ok, some could be grouped, but, even so, there are
>> drivers that implement the VIDIOC_G, but doesn't implement the corresponding VIDIO_S.
>> So, I think we don't have enough available bits for doing that.
> 
> It shouldn't be too hard to do an ioctl command that returns a le_bitmask with the
> ioctl command number as an index (0 to 91, currently), and the bit set for each
> command that has the corresponding v4l2_ioctl_ops member filled for the device.
> That would be an obvious way to query the operations, but I don't know if it's
> useful.

Tricks like that could be done, but that would not be consistent with other subsystems
that use -ENOTTY for such purpose. 

Also, to avoid having magic numbers, this will end by adding a somewhat complex logic 
at userspace (or having some sort of macro exported together with videodev2.h), in 
order to associate a V4L2 ioctl with the corresponding le_bitmask bit.

Also, 91 ioctls seems a complex-enough API to me. We should avoid adding more stuff there
without very good reasons.

In any case, we should also double check how this is done by the other API's used at the
media subsystem, and try to do the same there (lirc, Media Controller and DVB APIs).

My intention is to split the error handling changes from the original series that remove
the linux/version.h, and spend some time preparing a new RFC about that, trying to cover
all the API's defined under drivers/media. One idea could be to postpone a decision about
it, and discuss this topic further during the media workshop at the KS/2011.

Thanks,
Mauro.
