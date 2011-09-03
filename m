Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1ICFrw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:47:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40257 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1ICFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:47:50 -0400
MIME-Version: 1.0
Date: Sat, 3 Sep 2011 00:47:48 -0500
Message-ID: <CAErB21iHz_ToVzfU8aPkY8OW5iMOTPgPMdQBsmxo=5YUCMb6Aw@mail.gmail.com>
Subject: TLB flush question (x86_64)
From: Arkaprava Basu <arkaprava.basu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

     I am using 2.6.31 kernel on x86_64 (with SMP configuration). I
have a confusion on a TLB flush function.
     I found that the method tlb_flush_mmu (include/asm-generic/tlb.h)
, which is called by many system calls like munmap,madvise,mprotect
etc; ignores the virtual address range (start and end parameters) for
which it is called. It internally calls tlb_flush method, which on x86
gets converted to flush_tlb_mm. It seems that flush_tlb_mm flushes out
all the mappings for a given mm_struct (i.e., the whole user address
space for a process) from the tlb. Is there any particular reason why
the entire address space is flushed from the tlb while only a range of
virtual address space was supposedly required to be flushed? For
example why the method flush_tlb_range , which would have flushed
mappings belonging to a given virtual address range only could not
have been used instead of flush_tlb_mm? Is there any performance or
some other correctness related concern for not doing that?

Thanks
Arka
