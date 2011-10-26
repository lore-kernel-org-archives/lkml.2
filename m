Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab1JZPsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:48:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43729 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab1JZPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:48:08 -0400
Date: Wed, 26 Oct 2011 18:45:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] intel-iommu: Fix section mismatch in
 dmar_parse_rmrr_atsr_dev()
Message-ID: <20111026154539.GA10103@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dmar_parse_rmrr_atsr_dev() calls rmrr_parse_dev() and atsr_parse_dev() both
marked as __init.

Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the
function .init.text:dmar_parse_dev_scope()
The function dmar_parse_rmrr_atsr_dev() references
the function __init dmar_parse_dev_scope().

Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the
function .init.text:dmar_parse_dev_scope()
The function dmar_parse_rmrr_atsr_dev() references
the function __init dmar_parse_dev_scope().


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index be1953c..93cd72f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3523,7 +3523,7 @@ found:
 	return 0;
 }
 
-int dmar_parse_rmrr_atsr_dev(void)
+int __init dmar_parse_rmrr_atsr_dev(void)
 {
 	struct dmar_rmrr_unit *rmrr, *rmrr_n;
 	struct dmar_atsr_unit *atsr, *atsr_n;

