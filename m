Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1EEGYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:24:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1EEGYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:24:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
Date: Thu, 5 May 2011 08:24:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105050824.34056.arnd@arndb.de>
X-Provags-ID: V02:K0:KgIarJhf0YApytWUeXelEM90TBdFzfemYFhccXuhBxz
 sjsE725cr3PCQd7+ooIyBozMF7cg6gzkObiBLSQT9tl7jfMBGn
 H7Ty41r4P9L7y6zvb6yDT8hSqvsSjYNOAiXJADnEqJLC/c/KEk
 q9L+Cd7T0vLOL9Wi4PwuwejpvYtIrj1g65Mp5EL6uCpRtm3PlH
 7UwNQH0KHsZGxqyhZz2fA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 May 2011, Geert Uytterhoeven wrote:
> Impact for nommu:
>   - Store table in .rodata instead of .text,
>   - Let kernel/sys_ni.c handle the stubbing of MMU-only syscalls,
>   - Implement sys_mremap and sys_nfsservct,
>   - Remove unused padding at the end of the table.
> 
> Impact for mmu:
>   - Store table in .rodata instead of .data.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

What happened to the mmap syscall? IIRC, nommu is pointing to
a different symbol (sys_mmap_pgoff/sys_mmap2).

Did you check the macros in unistd to see if they match the
actual table? I guess it would be a good time to comment out
the ones that are not implemented in either of the two ABIs.

Otherwise, this patch looks good to me.

	Arnd
