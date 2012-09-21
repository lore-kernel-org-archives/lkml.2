Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2IUMwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:52:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab2IUMwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:52:13 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] lib: Add early cpio decoder
Date: Fri, 21 Sep 2012 14:51:12 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.20-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, robert.moore@intel.com,
        Fenghua Yu <fenghua.yu@intel.com>, initramfs@vger.kernel.org,
        bigeasy@linutronix.de, vojcek@tlen.pl, eric.piel@tremplin-utc.net,
        linux-acpi@vger.kernel.org, yinghai@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
References: <1346318957-5831-1-git-send-email-trenn@suse.de> <1346318957-5831-2-git-send-email-trenn@suse.de> <50463399.70506@zytor.com>
In-Reply-To: <50463399.70506@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211451.12523.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 04, 2012 07:00:09 PM H. Peter Anvin wrote:
> On 08/30/2012 02:29 AM, Thomas Renninger wrote:
> > From: "H. Peter Anvin" <hpa@linux.intel.com>
> >
> > Add a simple cpio decoder without library dependencies for the purpose
> > of extracting components from the initramfs blob for early kernel
> > uses.  Intended consumers so far are microcode and ACPI override.
> >
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > CC: Thomas Renninger <trenn@suse.de>
> > Link: http://lkml.kernel.org/r/201203261651.29640.trenn@suse.de
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> I was trying to figure out if there is a way to do what you want 
> (support for multiple files) without the problems of the callback 
> interface.  I think it is actually fairly straightforward; we need a 
> prefix iterator (so you can give it a string like "kernel/acpi/" rather 
> than a full filename) and it needs to be able to accept a "last" pointer 
> so it can resume scanning at the point it last left off.  That should be 
> a pretty trivial change.
Yep, this is a good idea.
 
> The other thing we presumably want to do -- and this is generic -- is to 
> be able to handle multiple sources for the initramfs; at the very least 
> there is built in vs provided from the boot loader.  I had originally 
> intended to just handle that by calling the earlycpio function once per 
> block, but the "last left off" bit makes that a little harder.  Need to 
> think about that a little bit.
I guess I understand the first part, not sure about the "last left off" 
bit.
"Multiple sources" means bootloader already points to multiple sources,
right?
This is somewhat out of scope as this would need both, bootloader and
kernel adjustings.
This is about "built in" which means multiple cpios concatenated together
and passed via bootloader as one "file" (initrd).
At least I understand it that way.
The only disadvantage I run into is that once the cpios are concatenated,
I couldn't figure out an easy way how to slice them into separate
cpio/zip archives again.

> I am guessing that this may not need to be something we need from the 
> very beginning, or am I wrong?

I have re-worked the patches:
  - added an offset argument to be able to iterate over files inside
    a directory as suggested
  - removed the strlen and memcmp function duplication in earlycpio.c
    This is not needed for this patchset and would be confusing.
    This can easily be added in the context of the patches which need it

I'll re-submit.

Thanks,

   Thomas
