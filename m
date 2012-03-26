Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2CZAps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 20:45:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2CZApp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 20:45:45 -0400
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Mon, 26 Mar 2012 02:45:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240402.38749.trenn@suse.de> <4F6D50DD.4050306@zytor.com>
In-Reply-To: <4F6D50DD.4050306@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203260245.43177.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2012 05:43:09 H. Peter Anvin wrote:
> On 03/23/2012 08:02 PM, Thomas Renninger wrote:
> >>
> >> Sorry, it doesn't work that way.
> > I guess this would not be the first time a good feature has been added,
> > knowing that a more general API will be build around it later.
> > 10 lines are really easy to adopt.
> > 
> 
> No, what you want is to add a new interface, which is going to have to
> be maintained indefinitely.  That's the problem.
It's a debug option...
Best would be if no distro specific mkinitrd magic is needed and it's
just as easy as it is:
cp DSDT.aml /boot/initrd-test
cat /boot/initrd >>/boot/initrd-test
and add a test boot entry to grub's menu.lst or whereever.
Then developers would not have to look at distro specific implementations
(which should not exist) about how to test a table quickly.
 
> >> I see two realistic options:
> >>
> >> 1. We use cpio encapsulation for everything, with a special namespace
> >>    for items used directly by the kernel, e.g. "kernel/".
> >>
> >>    + Simple, existing tools can pick apart
> >>    - May lead people to believe that the early-initrd portion can be
> >>      compressed like the "normal" initrd portion, leading to strange
> >>      problems.
> > Can this be implemented without using dynamic memory allocations?
> > If not, it's not suitable for early APCI overriding.
> 
> Yes it can, as long as it is uncompressed.  It just becomes a matter of
> walking the cpio headers which is effectively a linked list.
> 
> It is more code than the simple header option, though.
> 
> By the way, if "relying on the bootloader" was an option in any way

Why exactly is a change in the bootloader not an option?
Not sure whether a version number is passed, but the magic number could be
changed for now.

> then
> we would already have a solution in the form of the kernel data linked
> list.  Unfortunately to the best of my knowledge not a single bootloader
> provides support for it.
If the new magic number is passed, we get a linked list.
Otherwise we get it the old style and can still support that for several
years.
I agree that this should not be subject to change every here and there, but
"never ever change..." sounds as if something went wrong.
This is just an interface to the kernel, some apps, called bootloaders are
making use of?

It's not that I want to propagate a bigger change, I am all for the quick change
and proceed solution, I just wonder why above is not possible.

   Thomas
