Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1BBUF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:05:29 -0500
Received: from claw.goop.org ([74.207.240.146]:58555 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1BBUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:05:28 -0500
Message-ID: <4D49B903.2080602@goop.org>
Date: Wed, 02 Feb 2011 12:05:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <4D475DB5.1020300@zytor.com> <4D488EB1.9020803@goop.org> <4D49B5F6.5010606@zytor.com>
In-Reply-To: <4D49B5F6.5010606@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 11:52 AM, H. Peter Anvin wrote:
> As I mentioned on IRC...
>
> 1. Xen already uses Multiboot, so it's a fairly trivial thing to add
> another item to the list for the boot loader to get.
>
> 2. The only reason we don't currently install microcode from the boot
> loader is because of the considerable complexity in adding SMP support
> to boot loaders, as it requires handling the APIC system.
>
> 3. Arguably on native hardware we should still load the microcode into
> RAM in the boot loader, and install it on the very early CPU bringup
> path.  That means locking down some (currently) 400K of RAM to handle
> different combinations of CPUs, or the additional complexity of
> jettisoning microcode which cannot be used while still be able to deal
> with hotplug.  I think there is a strong case for this model, which
> would mean moving the microcode into /boot anyway.

If we can come up with a scheme that works for both native and Xen (or
at least v. similar) that we can get distros to support, then we can
work with that.  That principally means getting the microcode images
into /boot in a pre-digested form (binary, not text, and maybe pack the
Intel and AMD files together in some extensible way - or at least give
them self-describing headers).

But in the meantime it would be nice to have microcode updates under Xen
within the existing model (or failing that, a little patch to prevent
the spew of spurious errors when the kernel tries and fails - but it
would be strongly preferable to actually update microcode).

My main concern is that I want Xen to Just Work - ideally by not
requiring users/admins to do anything.

    J
