Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab1LESHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:07:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59132 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1LESHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:07:54 -0500
Date: Mon, 5 Dec 2011 10:07:06 -0800
From: tip-bot for Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Message-ID: <tip-c8f369ab6003a2df3cdae30f9aba641a4a606034@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ohad@wizery.com, joerg.roedel@amd.com, dwmw2@infradead.org,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ohad@wizery.com, dwmw2@infradead.org, joerg.roedel@amd.com,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111026154539.GA10103@swordfish>
References: <20111026154539.GA10103@swordfish>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] intel-iommu: Fix section mismatch in dmar_parse_rmrr_atsr_dev()
Git-Commit-ID: c8f369ab6003a2df3cdae30f9aba641a4a606034
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:07:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8f369ab6003a2df3cdae30f9aba641a4a606034
Gitweb:     http://git.kernel.org/tip/c8f369ab6003a2df3cdae30f9aba641a4a606034
Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
AuthorDate: Wed, 26 Oct 2011 18:45:39 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 18:22:51 +0100

intel-iommu: Fix section mismatch in dmar_parse_rmrr_atsr_dev()

dmar_parse_rmrr_atsr_dev() calls rmrr_parse_dev() and
atsr_parse_dev() which are both marked as __init.

Section mismatch in reference from the function
dmar_parse_rmrr_atsr_dev() to the function
.init.text:dmar_parse_dev_scope() The function
dmar_parse_rmrr_atsr_dev() references the function __init
dmar_parse_dev_scope().

Section mismatch in reference from the function
dmar_parse_rmrr_atsr_dev() to the function
.init.text:dmar_parse_dev_scope() The function
dmar_parse_rmrr_atsr_dev() references the function __init
dmar_parse_dev_scope().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Link: http://lkml.kernel.org/r/20111026154539.GA10103@swordfish
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..a004c39 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3524,7 +3524,7 @@ found:
 	return 0;
 }
 
-int dmar_parse_rmrr_atsr_dev(void)
+int __init dmar_parse_rmrr_atsr_dev(void)
 {
 	struct dmar_rmrr_unit *rmrr, *rmrr_n;
 	struct dmar_atsr_unit *atsr, *atsr_n;
