Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab0JTKgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:36:37 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33793 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0JTKgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:36:35 -0400
Date: Wed, 20 Oct 2010 12:36:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, ian.cambell@eu.citrix.com,
        jbeulich@novell.com, tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/mm] x86, mm: Hold mm->page_table_lock while doing
 vmalloc_sync
Message-ID: <20101020103642.GA3135@kryptos.osrc.amd.com>
References: <4CB88A4C.1080305@goop.org>
 <tip-617d34d9e5d8326ec8f188c616aa06ac59d083fe@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-617d34d9e5d8326ec8f188c616aa06ac59d083fe@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, Oct 19, 2010 at 10:17:37PM +0000

> Commit-ID:  617d34d9e5d8326ec8f188c616aa06ac59d083fe
> Gitweb:     http://git.kernel.org/tip/617d34d9e5d8326ec8f188c616aa06ac59d083fe
> Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> AuthorDate: Tue, 21 Sep 2010 12:01:51 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 19 Oct 2010 13:57:08 -0700

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 20 Oct 2010 12:23:48 +0200
Subject: [PATCH] x86, mm: Fix build warning on 32-bit

arch/x86/mm/fault.c: In function 'vmalloc_sync_all':
arch/x86/mm/fault.c:238: warning: assignment makes integer from pointer without a cast

introduced by 617d34d9e5d8326ec8f188c616aa06ac59d083fe.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 85c2eb9..79b0b37 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -230,7 +230,7 @@ void vmalloc_sync_all(void)
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
 			spinlock_t *pgt_lock;
-			int ret;
+			pmd_t *ret;
 
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
-- 
1.7.3.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
