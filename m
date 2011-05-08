Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1EHMv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:51:57 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42695 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752889Ab1EHMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:51:54 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v5 01/19] ARM: LPAE: Use long long printk format for displaying the pud
Date: Sun,  8 May 2011 13:51:20 +0100
Message-Id: <1304859098-10760-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 08 May 2011 12:51:47.0975 (UTC) FILETIME=[B15F3970:01CC0D7E]
X-MC-Unique: 111050813515101301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p48Cq6Zf020032

Currently using just long but this is not enough for the LPAE format
(64-bit entries).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bc0e1d8..ee76923 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -94,7 +94,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
 
 		pud = pud_offset(pgd, addr);
 		if (PTRS_PER_PUD != 1)
-			printk(", *pud=%08lx", pud_val(*pud));
+			printk(", *pud=%08llx", (long long)pud_val(*pud));
 
 		if (pud_none(*pud))
 			break;

