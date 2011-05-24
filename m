Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab1EXVoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:44:18 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34576 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757417Ab1EXVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:38 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 01/18] ARM: LPAE: Use long long printk format for displaying the pud
Date: Tue, 24 May 2011 22:39:07 +0100
Message-Id: <1306273164-18217-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:44.0443 (UTC) FILETIME=[18A0A8B0:01CC1A5B]
X-MC-Unique: 111052422393500501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLiVcs005114

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

