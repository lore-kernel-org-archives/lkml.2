Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2IFO4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:56:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14138 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab2IFO4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:56:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Sep 2012 07:48:44 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ARM: tegra: fix return value for debugfs init
Date: Thu, 6 Sep 2012 17:55:28 +0300
Message-ID: <1346943329-4898-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tegra_powergate_debugfs_init() always returns -ENOMEM. It shouldn't do that
when registering the debugfs entry succeeded.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/powergate.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index 15d5065..27aee4a 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -237,14 +237,13 @@ static const struct file_operations powergate_fops = {
 int __init tegra_powergate_debugfs_init(void)
 {
 	struct dentry *d;
-	int err = -ENOMEM;
 
 	d = debugfs_create_file("powergate", S_IRUGO, NULL, NULL,
 		&powergate_fops);
 	if (!d)
 		return -ENOMEM;
 
-	return err;
+	return 0;
 }
 
 #endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

