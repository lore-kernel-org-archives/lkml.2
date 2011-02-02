Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1BBUer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:34:47 -0500
Received: from www.tglx.de ([62.245.132.106]:42827 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1BBUep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:34:45 -0500
Date: Wed, 2 Feb 2011 21:34:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
In-Reply-To: <4D49B903.2080602@goop.org>
Message-ID: <alpine.LFD.2.00.1102022131030.31804@localhost6.localdomain6>
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org>
 <4D475DB5.1020300@zytor.com> <4D488EB1.9020803@goop.org> <4D49B5F6.5010606@zytor.com> <4D49B903.2080602@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Jeremy Fitzhardinge wrote:

> On 02/02/2011 11:52 AM, H. Peter Anvin wrote:
> > As I mentioned on IRC...
> >
> > 1. Xen already uses Multiboot, so it's a fairly trivial thing to add
> > another item to the list for the boot loader to get.
> >
> > 2. The only reason we don't currently install microcode from the boot
> > loader is because of the considerable complexity in adding SMP support
> > to boot loaders, as it requires handling the APIC system.
> >
> > 3. Arguably on native hardware we should still load the microcode into
> > RAM in the boot loader, and install it on the very early CPU bringup
> > path.  That means locking down some (currently) 400K of RAM to handle
> > different combinations of CPUs, or the additional complexity of
> > jettisoning microcode which cannot be used while still be able to deal
> > with hotplug.  I think there is a strong case for this model, which
> > would mean moving the microcode into /boot anyway.
> 
> If we can come up with a scheme that works for both native and Xen (or
> at least v. similar) that we can get distros to support, then we can
> work with that.  That principally means getting the microcode images
> into /boot in a pre-digested form (binary, not text, and maybe pack the
> Intel and AMD files together in some extensible way - or at least give
> them self-describing headers).
> 
> But in the meantime it would be nice to have microcode updates under Xen
> within the existing model (or failing that, a little patch to prevent
> the spew of spurious errors when the kernel tries and fails - but it
> would be strongly preferable to actually update microcode).
> 
> My main concern is that I want Xen to Just Work - ideally by not
> requiring users/admins to do anything.

Well, that's a noble goal, but the reality is that Xen is not even
close to the point where it Just Works. So instead of slapping some
weird workaround into the kernel, we really should go for the correct
solution right away.

Thanks,

	tglx
