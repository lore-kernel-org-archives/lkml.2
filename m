Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2HPUqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:46:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2HPUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:46:42 -0400
Date: Thu, 16 Aug 2012 13:46:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 00/15] firmware loader: introduce cache/uncache
 firmware
Message-ID: <20120816204638.GA4463@kroah.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
 <CACVXFVM_WY4v69jdQiG13B94rEPP1EzHXpetZRrTJwhmgT=S2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVM_WY4v69jdQiG13B94rEPP1EzHXpetZRrTJwhmgT=S2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 03:30:14PM +0800, Ming Lei wrote:
> On Sat, Aug 4, 2012 at 12:01 PM, Ming Lei <ming.lei@canonical.com> wrote:
> > Hi,
> >
> > In [1][2], the problem below has been discussed for some time:
> >
> >         device's firmware may be lost during suspend/resume
> >         cycle because device might be unplugged and plugged again
> >         or device experiences system power loss during the period.
> >         But in resume path, system is still not ready(process
> >         frozen, rootfs not usable, ...) to complete loading firmware
> >         from user space for devices.
> >
> > The conclusion is that caching firmware during suspend/resume cycle
> > is capable of solving the problem.
> >
> > This patchset implements cache/uncache firmware mechanism,
> > and apply the mechnism to cache device's firmware in kernel memory
> > space automatically during suspend/resume cyclye, so device can
> > load its firmware easily in its resume path. When resume is completed
> > and system is ready, the cached firmware will be removed from
> > kernel memory later.
> >
> > The patch 15/15 is one example to apply the firmware cache mechanism on
> > ath9k-htc driver.
> >
> > Even there are some corener cases[3] which can't be solved by the
> > cache approach, but as discussed in[4], the problem can be easily
> > fixed by a simple patch written by Linus.
> >
> > This patch set is against 3.6.0-rc1-next-20120803.
> >
> > [1]. http://marc.info/?t=134278790800004&r=1&w=2
> > [2]. http://marc.info/?t=132528956000002&r=10&w=2
> > [3]. http://marc.info/?l=linux-usb&m=132554118928398&w=2
> > [4]. http://marc.info/?l=linux-kernel&m=134323730805443&w=2
> >
> > --
> > V1:
> >         -handle vmap failure case(1/15)
> >         -fix a memory leak of 'firmware_buf'(5/15)
> >         -fix oops during failure path of requesting firmware(6/15)
> >         -fix vmap more than one time(6/15)
> >         -introduce __fw_lookup_buf to avoid code duplication(7/15)
> >         -fix comment of request_firmware_nowait(9/15)
> >         -avoid releasing lock in devres_for_each_res(11/15)
> >         -use new devres iterator API to create fw cache entry(12/15)
> >         -rename some functions and data structures(12/15)
> >         -some code style fixes
> >
> >         Thanks for Borislav's review!
> 
> Gentle ping on -V1, :-)

Ok, these look good to me, so I've applied the first 14 to the
driver-core-next tree to get some testing by others.

I didn't feel I could add the 15th patch without some acks from those
developers, or at least someone who says "it works for me!".

Also, what about those other patches you reference in your footnotes
above, what's the status of them?

thanks,

greg k-h
