Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1CADkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 22:40:40 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33897 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1CADkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 22:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=joDeswIPjl9ahP34IFTIvxpR+dbV82+KlsYvDZcU7LXtmqdANKvfCxDGmqh0e36B0W
         pi2gBQrWd/5DmF0ZvK1T4wjKHoo1uDPwBGx+dkhvZhLP5cSJvo9YUcBQdyuUAWtF6Ktm
         Q14Tzdo+7QNGKxBqygT/1H1QgDjqgJSUkd4Mk=
MIME-Version: 1.0
In-Reply-To: <20110224121042.6fa3fe37@lxorguk.ukuu.org.uk>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
	<AANLkTimPpr+OugTiPpYxNyS78vqActuURw-tnxJVxi18@mail.gmail.com>
	<20110224121042.6fa3fe37@lxorguk.ukuu.org.uk>
Date: Tue, 1 Mar 2011 13:40:38 +1000
Message-ID: <AANLkTikXwLSpO2WNKpC=7y7g13qx1cmyCOG7HSrOUgzt@mail.gmail.com>
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:10 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> So where do we want to go my opinion is
>>
>> a) remove all userspace interfaces and simplify ttm memory management usage.
>
> Some of them appear to be valid/sensible ones for querying mode data and
> config bits. I'm slowly pruning out the rest
>
>> b) add support to hook this up to the dumb ioctl so we can do trivial
>> generic front buffer allocation, so then a libkms + dumb kms
>> modesetting driver can work on it.
>
> What sort of dumb ioctl do you have in mind ?

Its already in my drm-next tree,
http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=ff72145badb834e8051719ea66e024784d000cb4

the idea being we can allocate and map a buffer that we can use for
doing dumb operations in an fbdev like manner,
the handles can be passed to the normal generic drm KMS ioctls. It
avoids simple userspaces having to know about the
per-driver GEM accel interfaces. Of course to add acceleration you
need to get off this interface but it at least means
getting something simple up and running with full KMS output control.

>
>> c) figure out how to add interface for acceleration users. Whether TTM
>> fence interfaces are required etc.
>
> The fencing seems to be solely for the various capture/acceleration bits
> for video as far as I can tell.
>
> It seems we need two things - issue a 2D command and stuff for
> transferring objects, although it's not clear that the latter is needed.
>
> The old X 2D code is at:
> http://git.moblin.org/cgit.cgi/deprecated/xf86-video-psb/

Okay I'll try and have a look at that and see whats its doing.

Dave.
