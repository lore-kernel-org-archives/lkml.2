Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab0IBEYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 00:24:55 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:33914 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750842Ab0IBEYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 00:24:53 -0400
Date: Thu, 2 Sep 2010 14:24:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201009020424.o824OQ16022641@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-m68k@vger.kernel.org>
Subject: [PATCH] m68knommu: fix missing linker segments
To: <linux-kernel@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 2.0)
X-OriginalArrivalTime: 02 Sep 2010 04:24:48.0837 (UTC) FILETIME=[C7B51F50:01CB4A56]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes to linker segments that hold per-cpu data broke linking
for m68knommu targets:

  LD      vmlinux
/usr/local/bin/m68k-uclinux-ld.real: error: no memory region specified for loadable section `.data..shared_aligned'

Add missing segments into the m68knommu linker script.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>


diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index a91b271..ef33213 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -150,6 +150,8 @@ SECTIONS {
 		_sdata = . ;
 		DATA_DATA
 		CACHELINE_ALIGNED_DATA(32)
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
+		*(.data..shared_aligned)
 		INIT_TASK_DATA(THREAD_SIZE)
 		_edata = . ;
 	} > DATA
