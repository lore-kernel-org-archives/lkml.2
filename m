Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2HPIpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:45:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35382 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2HPIpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:45:51 -0400
MIME-Version: 1.0
Date: Thu, 16 Aug 2012 16:45:49 +0800
Message-ID: <CAEk7JKZMuOEX_cAaHcbExzjLWPtO==B4mmwcjTsh-ppGQpJDcw@mail.gmail.com>
Subject: [PATCH 1/1] fix a compiling error caused by dmar_disabled
From: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a compiling error caused by dmar_disabled.

When CONFIG_INTEL_IOMMU is not defined, dmar_disabled is define as 1,
and the codes like "dmar_disabled = 1;" may cause compiling error.

-------

Signed-off-by: Li, Zhen-Hua <lizhenhua.dev@gmail.com>

diff -urp a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c	2012-07-22 04:58:29.000000000 +0800
+++ b/drivers/iommu/intel-iommu.c	2012-08-15 16:05:56.000000000 +0800
@@ -425,7 +425,7 @@ static long list_size;

 static void domain_remove_dev_info(struct dmar_domain *domain);

-#ifdef CONFIG_INTEL_IOMMU_DEFAULT_ON
+#if defined(CONFIG_INTEL_IOMMU_DEFAULT_ON) && defined(CONFIG_INTEL_IOMMU)
 int dmar_disabled = 0;
 #else
 int dmar_disabled = 1;
diff -urp a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
--- a/include/linux/dma_remapping.h	2012-07-22 04:58:29.000000000 +0800
+++ b/include/linux/dma_remapping.h	2012-08-15 16:05:59.000000000 +0800
@@ -44,7 +44,6 @@ static inline int iommu_calculate_max_sa
 static inline void free_dmar_iommu(struct intel_iommu *iommu)
 {
 }
-#define dmar_disabled	(1)
 #define intel_iommu_enabled (0)
 #endif
