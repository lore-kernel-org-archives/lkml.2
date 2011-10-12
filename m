Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1JLUlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:41:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab1JLUlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:41:35 -0400
Date: Wed, 12 Oct 2011 14:36:14 -0600
From: Greg KH <gregkh@suse.de>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111012203614.GB14572@suse.de>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
 <20111012141724.GA17414@suse.de>
 <4E95D5C6.8040404@ionic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E95D5C6.8040404@ionic.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:00:38PM +0200, Mihai Moldovan wrote:
> Hi Greg,
> 
> * On 12.10.2011 04:17 PM, Greg KH wrote:
> > As stated before, this patch is not acceptable. Please work to figure
> > out the real reason for your device problems here, this is not the
> > correct solution at all.
> 
> I've gone through this whole (and previous) thread, but couldn't find a
> real argument why this is so wrong.

Because it does nothing except increase kernel memory pressure.  Why not
increase it to 1Gb while we are at it, it realistically makes no
difference.

And so, because it makes no difference, we should not change the
existing value as there seems to be something else wrong with what is
going on here in the userspace code that can't handle smaller buffer
sizes.

Within the kernel, and the host controller driver, the memory is split
up into much smaller pieces anyway, so there should not be any
difference at all, if you write your userspace code correctly, that the
USB device would see anything different with a bigger (or even smaller)
usbfs buffer size.

> So far everybody has argued that it's 'wrong' and may break older user
> code. The latter argument even is wrong, as drivers not requiring a
> higher bulk transfer size just aren't affected.
> 
> This being said, I agree that allocating more memory than needed is
> wasting memory and bad, if it can be avoided. On the other hand, we're
> talking about very few devices here and not several ten of MB system
> memory being wasted by all bulk transfers in total.
> I basically see two cases:
>   - systems with a few MB of RAM. I highly doubt those use usbfs anyway
> (usually other stuff like usb-storage)

Not true at all, I know of some using usbfs quite well, and have been
since the 2.2 kernel days.

greg k-h
