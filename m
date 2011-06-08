Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1FHVcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:32:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab1FHVct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110608212813.GB32056@srcf.ucam.org>
References: <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org>
 <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org>
 <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org>
 <20110608204244.GA31484@srcf.ucam.org> <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com>
 <20110608212813.GB32056@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Jun 2011 14:31:55 -0700
Message-ID: <BANLkTikbx6xm+NY34ATN7YkJyjPp9CSXTw@mail.gmail.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 2:28 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Boot services data includes everything that was allocated by the EFI
> memory allocator. Depending on what the system decided to do before
> deigning to run our code, that might be a meg - or it might be several
> hundred. And in the process it's probably fragmented RAM into god knows
> how many small chunks.

In reality?

Whatever. I really think our EFI support is just fundamnetally broken.
We should do *everything* in the bootloader, and nothing at all in the
kernel. IOW, I think doing the whole "SetVirtualAddrMap()" (or
whatever) in the boot loader too, and just promise to neve rever call
any EFI routines from the kernel.

IOW, a sane EFI boot loader should just make things look like a
regular BIOS, and not bother the kernel with the EFI crap.

EFI was misdesigned. That doesn't mean that _we_ should then
mis-design our support for it.

                          Linus
