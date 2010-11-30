Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0K3MPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 07:15:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43141 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0K3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 07:15:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YVcpq8janHYv7oNFwTsLN7HZC0Bnbef6d8+F33+WiLOBR+7cUG2gKWyRHBg1L5VMbA
         FMlpphiQFTI75i25Ai2XuUYlQ/JNmh5eVqyXeMoXvRXlUuaZuDZ4PrNfqKSZ6JAE5ikS
         wALENGwguweryvv7fHg+lPhidiFnA+lNvt5Ew=
Subject: Re: When was ASLR introduced in the Linux kernel?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Victor van der Veen <vvdveen@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1291117660.3206.11.camel@D430>
References: <1291117660.3206.11.camel@D430>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 13:15:24 +0100
Message-ID: <1291119324.2904.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 novembre 2010 à 12:47 +0100, Victor van der Veen a écrit :
> Hi,
> 
> - When was ASLR introduced in the Linux kernel (not PaX/ExecShield)? 
> - When was ASLR enabled by default? 
> - What's the current state of ASLR in the Linux kernel? Is it still
> under development? Or should we rely on the PaX/ExecShield patches?
> 
> Wikipedia states that "a weak form of ASLR exists in the linux kernel
> since version 2.6.12 (June 2005)", but I could not find any proof that
> backs this up. I grepped changelogs of the entire 2.6 kernel, but I was
> unable to find any relevant information. Grepping the source code did
> not help either. Any more Google results all quote the same wikipedia
> line. 
> 

randomize-va-space:

echo  val >/proc/sys/kernel/randomize_va_space


vi +391 Documentation/sysctl/kernel.txt

This option can be used to select the type of process address
space randomization that is used in the system, for architectures
that support this feature.

0 - Turn the process address space randomization off.  This is the
    default for architectures that do not support this feature anyways,
    and kernels that are booted with the "norandmaps" parameter.

1 - Make the addresses of mmap base, stack and VDSO page randomized.
    This, among other things, implies that shared libraries will be
    loaded to random addresses.  Also for PIE-linked binaries, the
    location of code start is randomized.  This is the default if the
    CONFIG_COMPAT_BRK option is enabled.

2 - Additionally enable heap randomization.  This is the default if
    CONFIG_COMPAT_BRK is disabled.

    There are a few legacy applications out there (such as some ancient
    versions of libc.so.5 from 1996) that assume that brk area starts
    just after the end of the code+bss.  These applications break when
    start of the brk area is randomized.  There are however no known
    non-legacy applications that would be broken this way, so for most
    systems it is safe to choose full randomization.

    Systems with ancient and/or broken binaries should be configured
    with CONFIG_COMPAT_BRK enabled, which excludes the heap from process
    address space randomization.



