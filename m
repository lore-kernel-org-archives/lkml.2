Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab1BCSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:25:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54318 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214Ab1BCSZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:25:54 -0500
Date: Thu, 3 Feb 2011 19:25:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110203182550.GB21488@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen Devel <Xen-devel@lists.xensource.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <4D461FB9.5050807@goop.org>
 <20110131070241.GA22071@liondog.tnic>
 <4D46FC9F.6090309@goop.org>
 <20110131234131.GA16095@liondog.tnic>
 <4D475099.1080004@goop.org>
 <4D475DB5.1020300@zytor.com>
 <4D488EB1.9020803@goop.org>
 <4D49B5F6.5010606@zytor.com>
 <20110202205704.GA14752@liondog.tnic>
 <4D49D0E6.30102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D49D0E6.30102@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 01:47:18PM -0800, H. Peter Anvin wrote:
> On 02/02/2011 12:57 PM, Borislav Petkov wrote:
> > On Wed, Feb 02, 2011 at 11:52:22AM -0800, H. Peter Anvin wrote:
> >> 3. Arguably on native hardware we should still load the microcode into
> >> RAM in the boot loader, and install it on the very early CPU bringup
> >> path.  That means locking down some (currently) 400K of RAM to handle
> >> different combinations of CPUs, or the additional complexity of
> >> jettisoning microcode which cannot be used while still be able to deal
> >> with hotplug.  I think there is a strong case for this model, which
> >> would mean moving the microcode into /boot anyway.
> > 
> > /me like it, sounds very nifty. So how do we want to do that, we add
> > a field to the real-mode kernel header that tells us where to find
> > the microcode image and we take it and apply the ucode somewhere in
> > do_boot_cpu() path?
> > 
> 
> We already have a mechanism for passing arbitrary blobs -- the linked
> list -- so we don't have to add a new field at all.

So, after staring at grub legacy sources a bit, we could load the
microcode image using the grub module's mechanism:

kernel /...
module /boot/microcode.gz type=SETUP_MICROCODE # this is looked at by parse_setup_data()

and let grub write the pointer into setup_data passed through the kernel
header.

This would mean that we need to add support to a bunch of boot loaders
used currently, no? Or is there an even better way?

-- 
Regards/Gruss,
Boris.
