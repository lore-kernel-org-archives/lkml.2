Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1EIDEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 23:04:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1EIDEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 23:04:36 -0400
Date: Sun, 8 May 2011 15:58:47 -0700
From: Greg KH <gregkh@suse.de>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: Alan Stern <stern@rowland.harvard.edu>, mfuzzey@gmail.com,
        tom.leiming@gmail.com, ak@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix warning in usbtest module
Message-ID: <20110508225847.GA12750@suse.de>
References: <Pine.LNX.4.44L0.1105081033140.30441-100000@netrider.rowland.org>
 <4DC6EB3B.8070604@cuw.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC6EB3B.8070604@cuw.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 02:12:59PM -0500, Greg Dietsche wrote:
> On 05/08/2011 09:37 AM, Alan Stern wrote:
> >On Sat, 7 May 2011, Greg Dietsche wrote:
> >
> >>On amd64 unsigned is not as wide as pointer and this causes
> >>a compiler warning. Switching to uintptr_t fixes the problem
> >>in an arch independent manner.
> >People tend to prefer to see non-typedef'ed type names, whenever
> >possible.  In this case, it would be enough to change the type to
> >unsigned long.
> >
> >Lots of code throughout the kernel stores pointer values in unsigned
> >long variables.  I've never heard any recommendation for using
> >uintptr_t instead.
> >
> I was leaning towards unsigned long at first too, but a several
> things made me reconsider:
> 1) uintptr_t adapts correctly to the size of a pointer on all
> architectures per C99
> 2) I greped the kernel source and found a number of instances where
> uintptr_t is used
> 3) unsigned long is technically too wide (though this is better than
> too small...) for some architectures
> 
> If the general consensus is that unsigned long is a better choice
> for the kernel, I will update my patch. I do, however think that
> uintptr_t is the best choice from a technical perspective and prefer
> it over unsigned long.

Sorry, but no, use 'unsigned long' please.  In the kernel, it's
guaranteed to hold the size of a pointer, that is one of the
requirements of Linux.

And as for C99, those types don't make any sense in the kernel, only in
userspace.  See Linus's posts on this a few years back on lkml if you
want all of the details.

So please redo this patch with 'unsigned long' and I will be glad to
queue it up.

thanks,

greg k-h
