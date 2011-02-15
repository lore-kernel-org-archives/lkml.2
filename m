Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1BOGhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:37:18 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40266 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1BOGhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:37:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NyQd4/u3wID/FooLHyL276/JqpM8qVYBZGDuDu3DHI8ayxEqJdhzVv4I+Ciby4NZve
         AG00P4I/0uiqoIivizQzlobWysFn6ZZJro8d93JhRLPYhw6lCX9rLM/xkBONKC3kgst0
         mmvaZmNipxEoj3JqudCqc3XqnR1Jzugfdja3s=
MIME-Version: 1.0
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
Date: Mon, 14 Feb 2011 22:37:14 -0800
X-Google-Sender-Auth: yR7ALsKVS7FM_Z6f6ns3_Zun-LM
Message-ID: <AANLkTinS-oNR8KU6i9yWtHGp7PChehiUrF8fTT9zTtP-@mail.gmail.com>
Subject: Re: [PATCH -v2 0/11] x86: memblock related cleanup
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 3:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> 1. allocate bootmem with memblock will follow top-down
> 2. make page table cold be as high and on local node.
> 3. seperate bootmem.c into nobootmem.c.
>
> [PATCH 01/11] memblock: Don't adjust size in memblock_find_base()
> [PATCH 02/11] x86, mm, 64bit: Put early page table high.
> [PATCH 03/11] x86, 64bit, gart: Fix allocation with memblock
> [PATCH 04/11] memblock: Make find_memory_core_early() find from top-down
> [PATCH 05/11] x86: Change get_max_mapped() to inline
> [PATCH 06/11] x86, 64bit, numa: Allocate memnodemap under max_pfn_mapped
> [PATCH 07/11] x86, 64bit, numa: Put pgtable to local node memory
> [PATCH 08/11] x86: Rename e820_table_* to pgt_buf_*
> [PATCH 09/11] bootmem: Add nobootmem.c to reduce the #ifdef
> [PATCH 10/11] mm: Move contig_page_data define to bootmem.c/nobootmem.c
> [PATCH 11/11] memblock: Move __alloc_memory_core_early() to nobootmem.c
>
> First patch is already in -mm, but better to go with this patchset as patch 3 need that.
> and patch 4 is depending patch 3.
>

Ingo,

patch1 is in mainline already via Andrew path.
patch2 to patch7 are in tip/x86/bootmem, and now it is in tip/master.

please check
  git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git
memblock

for last four patches.
main change is creating nobootmem.c for memblock bootmem wrapper.


 arch/x86/include/asm/init.h |    6 +-
 arch/x86/mm/init.c          |   20 +-
 arch/x86/mm/init_32.c       |    8 +-
 arch/x86/mm/init_64.c       |    4 +-
 arch/x86/xen/mmu.c          |    2 +-
 include/linux/mm.h          |    2 -
 mm/Makefile                 |    8 +-
 mm/bootmem.c                |  180 +-----------------
 mm/nobootmem.c              |  435 +++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |   37 ----
 10 files changed, 472 insertions(+), 230 deletions(-)
 create mode 100644 mm/nobootmem.c


Thanks

Yinghai Lu
