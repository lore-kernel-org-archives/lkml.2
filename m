Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1FCNzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab1FCNzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:55:48 -0400
Message-ID: <4DE8E7D9.9000608@redhat.com>
Date: Fri, 03 Jun 2011 10:55:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Hans Petter Selasky <hselasky@c2i.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
 structure is transferred from userspace to kernelspace. Keep the old ioctl
 around for compatibility so that existing code is not broken.
References: <201105231558.13084.hselasky@c2i.net> <4DDA711E.3030301@linuxtv.org> <201105231651.55945.hselasky@c2i.net> <4DDA7E07.7070907@linuxtv.org> <4DE6ABF5.6020008@redhat.com> <4DE8D72E.7010300@linuxtv.org>
In-Reply-To: <4DE8D72E.7010300@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-06-2011 09:44, Andreas Oberritter escreveu:
> On 06/01/2011 11:15 PM, Mauro Carvalho Chehab wrote:
>> The dvb_usercopy will do the right thing, if we use _IOR or _IORW.
> 
> It only works, because _IOC_READ triggers a copy_from_user, as a
> workaround for wrongly marked ioctls like this, according to a code
> comment. It does not really do the right thing, because in this special
> case the later call to copy_to_user isn't required. But it doesn't do
> any real harm either.

Yes, that's what I meant to say ;) The workaround for it is there already,
so maybe there are other ioctl's using the wrong _IOC_ directions.

As I said before, some ioctl's don't use _IOC_ directions, like for example
the tty ioctls like TIO* ones. This happens on several very old drivers.
So, ioctl core don't make any assumption about them. it is up to each driver
(or subsystem core) to handle it.

>> I prefer to not apply this patch, as it won't fix anything. Adding an _OLD means
>> that we'll need later to remove it, causing a regression. Ok, we may do like we did
>> with V4L _OLD ioctl's that were marked as _OLD at 2.6.5 and were removed on a late
>> 2.6.3x.
> 
> Either way is fine for me.

I'm not against fixing it, but, in this case, we'll need to validate all DVB
ioctl's and remove the IOC_READ hack for all non-_OLD controls, and writing
a notice at features-to-be-removed announcing that the _OLD controls will be
removed.

Cheers,
Mauro.
> 
> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

