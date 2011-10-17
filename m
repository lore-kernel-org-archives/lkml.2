Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1JQUGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:06:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48889 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1JQUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:06:08 -0400
Message-ID: <4E9C8AAC.7080803@gmail.com>
Date: Mon, 17 Oct 2011 22:06:04 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org> <1318848017-12301-11-git-send-email-matt@console-pimps.org>
In-Reply-To: <1318848017-12301-11-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Matt,

On 10/17/2011 12:40 PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> There is currently a large divide between kernel development and the
> development of EFI boot loaders. The idea behind this patch is to give
> the kernel developers full control over the EFI boot process. As
> H. Peter Anvin put it,
>
> "The 'kernel carries its own stub' approach been very successful in
> dealing with BIOS, and would make a lot of sense to me for EFI as
> well."
>
> This patch introduces an EFI boot stub that allows an x86 bzImage to
> be loaded and executed by EFI firmware. The bzImage appears to the
> firmware as an EFI application. Luckily there are enough free bits
> within the bzImage header so that it can masquerade as an EFI
> application, thereby coercing the EFI firmware into loading it and
> jumping to its entry point. The beauty of this masquerading approach
> is that both BIOS and EFI boot loaders can still load and run the same
> bzImage, thereby allowing a single kernel image to work in any boot
> environment.
>
> The EFI boot stub supports multiple initrds, but they must exist on
> the same partition as the bzImage. Command-line arguments for the
> kernel can be appended after the bzImage name when run from the EFI
> shell, e.g.
>
> Shell> bzImage console=ttyS0 root=/dev/sdb initrd=initrd.img
Seems initrd is failing for me. Is there any limitation on the size of the initrd? The default one fedora generates for my kernel is 46mb. It loads the kernel, but it reboots before it gets to userspace. Loading the kernel and initrd with grub2-efi works. EFI booting without initrd works too.

Cheers,
Maarten
