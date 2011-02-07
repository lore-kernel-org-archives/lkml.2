Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1BGXTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:19:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34802 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab1BGXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:19:04 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 0/11] x86: memblock related cleanup
Date: Mon,  7 Feb 2011 15:17:01 -0800
Message-Id: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D507D91.00D6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. allocate bootmem with memblock will follow top-down
2. make page table cold be as high and on local node.
3. seperate bootmem.c into nobootmem.c.

[PATCH 01/11] memblock: Don't adjust size in memblock_find_base()
[PATCH 02/11] x86, mm, 64bit: Put early page table high.
[PATCH 03/11] x86, 64bit, gart: Fix allocation with memblock
[PATCH 04/11] memblock: Make find_memory_core_early() find from top-down
[PATCH 05/11] x86: Change get_max_mapped() to inline
[PATCH 06/11] x86, 64bit, numa: Allocate memnodemap under max_pfn_mapped
[PATCH 07/11] x86, 64bit, numa: Put pgtable to local node memory
[PATCH 08/11] x86: Rename e820_table_* to pgt_buf_*
[PATCH 09/11] bootmem: Add nobootmem.c to reduce the #ifdef
[PATCH 10/11] mm: Move contig_page_data define to bootmem.c/nobootmem.c
[PATCH 11/11] memblock: Move __alloc_memory_core_early() to nobootmem.c

First patch is already in -mm, but better to go with this patchset as patch 3 need that.
and patch 4 is depending patch 3.

Thanks

Yinghai Lu
