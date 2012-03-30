Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab2C3KYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:24:51 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52238 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662Ab2C3KSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:37 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 50/76] cpuidle: remove useless array definition in
 cpuidle_structure
Date: Fri, 30 Mar 2012 06:13:53 -0400
Message-id: <db70b04407a63668e5fee773f76f90367492fd25.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

All the modules name are ro-data, it is never copied to the array.

eg.

static struct cpuidle_driver intel_idle_driver = {
        .name = "intel_idle",
        .owner = THIS_MODULE,
};

It safe to assign the pointer of this ro-data to a const char *.
By this way we save 12 bytes.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Tested-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/cpuidle.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index ca4e498..f7f1d90 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -120,7 +120,7 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
  ****************************/
 
 struct cpuidle_driver {
-	char			name[CPUIDLE_NAME_LEN];
+	const char		*name;
 	struct module 		*owner;
 
 	unsigned int		power_specified:1;
-- 
1.7.10.rc2.19.gfae9d

