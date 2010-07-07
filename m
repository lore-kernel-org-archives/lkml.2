Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab0GGVmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:42:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab0GGVks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 05/18] arm/omap: use generic_file_llseek in iommu_debug
Date: Wed,  7 Jul 2010 23:40:07 +0200
Message-Id: <1278538820-1392-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Y5evt7EVGQhiYQXlWigpFwCeQSXKK1B2JHUblFNzZnW
 TQr7yZ+Cgv5H7WrZDA56IhfUlVFPr7w1DhdxbKOJVS0pRNgZxz
 KDZJEv4fYtkwztFUyUFW5uAgeaNWQV2fhnEVkGwnXRjY68JhJN
 8O4Gt3uZa2Pa83Vak2zEAdrlwn31XfBH8wIpIy+B6ws35f3VMD
 FMPeXpdhKNu3ybW/m6oZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In future kernels, debugfs files need to specify
the llseek operation explicitly to allow seeking.
This sets the llseek operation in the omap iommu
debugfs files to generic_file_llseek, which is
appropriate for files using simple_read_from_buffer.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
---
 arch/arm/plat-omap/iommu-debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/iommu-debug.c b/arch/arm/plat-omap/iommu-debug.c
index e6c0d53..f07cf2f 100644
--- a/arch/arm/plat-omap/iommu-debug.c
+++ b/arch/arm/plat-omap/iommu-debug.c
@@ -328,12 +328,14 @@ static int debug_open_generic(struct inode *inode, struct file *file)
 		.open = debug_open_generic,				\
 		.read = debug_read_##name,				\
 		.write = debug_write_##name,				\
+		.llseek = generic_file_llseek,				\
 	};
 
 #define DEBUG_FOPS_RO(name)						\
 	static const struct file_operations debug_##name##_fops = {	\
 		.open = debug_open_generic,				\
 		.read = debug_read_##name,				\
+		.llseek = generic_file_llseek,				\
 	};
 
 DEBUG_FOPS_RO(ver);
-- 
1.7.1

