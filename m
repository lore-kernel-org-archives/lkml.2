Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab0GPUMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:12:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50150 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759249Ab0GPUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:12:48 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Question about binfmt_elf.c
Date: Fri, 16 Jul 2010 15:12:39 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-19-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007161512.40388.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could somebody please update this comment to explain why fiddling with 
strangely protected bss is _not_ an easy way to leak arbitrary amounts of 
uninitalized kernel memory (with whatever previous contents they have) to 
userspace?

    nbyte = ELF_PAGEOFFSET(elf_bss);
    if (nbyte) {
            nbyte = ELF_MIN_ALIGN - nbyte;
            if (nbyte > elf_brk - elf_bss)
                        nbyte = elf_brk - elf_bss;
            if (clear_user((void __user *)elf_bss +
                                    load_bias, nbyte)) {
                    /*
                     * This bss-zeroing can fail if the ELF
                     * file specifies odd protections. So
                     * we don't check the return value
                      */
            }
    }

Just curious.  Reading through the code and trying to understand it...

Rob
-- 
GPLv3: as worthy a successor as The Phantom Meanace, as timely as Duke Nukem 
Forever, and as welcome as New Coke.
