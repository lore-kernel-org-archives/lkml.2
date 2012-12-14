Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2LNNS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:18:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3007 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2LNNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:18:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 14 Dec 2012 05:16:38 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <rafael.j.wysocki@intel.com>, <daniel.lezcano@linaro.org>,
        <shuox.liu@intel.com>, <akpm@linux-foundation.org>,
        <yanmin_zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, Sivaram Nair <sivaramn@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] cpuidle: fix sysfs output for power_usage
Date: Fri, 14 Dec 2012 15:17:37 +0200
Message-ID: <1355491060-970-2-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
References: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle_state->power_usage is signed; so change the corresponding sysfs
ops to output signed value instead of unsigned.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 drivers/cpuidle/sysfs.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 3409429..2fc79cd 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -232,6 +232,13 @@ static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, show, store)
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
 			 struct cpuidle_state_usage *state_usage, char *buf) \
 { \
+	return sprintf(buf, "%d\n", state->_name);\
+}
+
+#define define_show_state_u_function(_name) \
+static ssize_t show_state_##_name(struct cpuidle_state *state, \
+			 struct cpuidle_state_usage *state_usage, char *buf) \
+{ \
 	return sprintf(buf, "%u\n", state->_name);\
 }
 
@@ -270,7 +277,7 @@ static ssize_t show_state_##_name(struct cpuidle_state *state, \
 	return sprintf(buf, "%s\n", state->_name);\
 }
 
-define_show_state_function(exit_latency)
+define_show_state_u_function(exit_latency)
 define_show_state_function(power_usage)
 define_show_state_ull_function(usage)
 define_show_state_ull_function(time)
-- 
1.7.9.5

