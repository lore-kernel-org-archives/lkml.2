Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab1LESIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:08:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1LESIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:08:10 -0500
Date: Mon, 5 Dec 2011 10:07:52 -0800
From: tip-bot for Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Message-ID: <tip-61ed26e388ac67da262bb1a95d0474e4cabd4b0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ohad@wizery.com, sergey.senozhatsky@gmail.com, youquan.song@intel.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ohad@wizery.com, suresh.b.siddha@intel.com,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de,
        youquan.song@intel.com, mingo@elte.hu
In-Reply-To: <20111026161507.GB10103@swordfish>
References: <20111026161507.GB10103@swordfish>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] intr_remapping: Fix section mismatch in ir_dev_scope_init()
Git-Commit-ID: 61ed26e388ac67da262bb1a95d0474e4cabd4b0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:07:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61ed26e388ac67da262bb1a95d0474e4cabd4b0d
Gitweb:     http://git.kernel.org/tip/61ed26e388ac67da262bb1a95d0474e4cabd4b0d
Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
AuthorDate: Wed, 26 Oct 2011 19:15:07 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 18:22:53 +0100

intr_remapping: Fix section mismatch in ir_dev_scope_init()

Fix:

 Section mismatch in reference from the function
 ir_dev_scope_init() to the function
 .init.text:dmar_dev_scope_init() The function
 ir_dev_scope_init() references the function __init dmar_dev_scope_init().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Youquan Song <youquan.song@intel.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Link: http://lkml.kernel.org/r/20111026161507.GB10103@swordfish
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/iommu/intr_remapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 07c9f18..6777ca0 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -773,7 +773,7 @@ int __init parse_ioapics_under_ir(void)
 	return ir_supported;
 }
 
-int ir_dev_scope_init(void)
+int __init ir_dev_scope_init(void)
 {
 	if (!intr_remapping_enabled)
 		return 0;
