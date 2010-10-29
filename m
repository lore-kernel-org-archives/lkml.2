Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab0J2EkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:40:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38019 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab0J2EkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:40:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4CCA508F.3090903@np.css.fujitsu.com>
Date: Fri, 29 Oct 2010 13:41:51 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H.Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] [x86, next] Fix unsuitable attributes of mce debugfs.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug interfaces of mce should be desired to do following operations
    - Write operation as root user
    - Read operation as all users
for debugging mce functionality.

But the real attributes of interfaces of mce are 0444.
Though the attributes of interfaces do not give any impact to
debug mce functionality, I still think that the attributes of
interfaces should be changed from 0444 to 0644.

I tested this patch on Intel64 next-tree.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 1e8d66c..f9e6376 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -203,7 +203,7 @@ static int __init severities_debugfs_init(void)
 	if (dmce == NULL)
 		goto err_out;
 	fseverities_coverage = debugfs_create_file("severities-coverage",
-						   0444, dmce, NULL,
+						   0644, dmce, NULL,
 						   &severities_coverage_fops);
 	if (fseverities_coverage == NULL)
 		goto err_out;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7a35b72..8edb04d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2200,7 +2200,7 @@ static int __init mcheck_debugfs_init(void)
 	dmce = mce_get_debugfs_dir();
 	if (!dmce)
 		return -ENOMEM;
-	ffake_panic = debugfs_create_file("fake_panic", 0444, dmce, NULL,
+	ffake_panic = debugfs_create_file("fake_panic", 0644, dmce, NULL,
 					  &fake_panic_fops);
 	if (!ffake_panic)
 		return -ENOMEM;
-- 
1.7.2.2

