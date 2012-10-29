Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524Ab2J2UDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:03:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57000 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704Ab2J2UB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:01:59 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next PATCH 3/7] PM / devfreq: register governors with devfreq framework
Date: Mon, 29 Oct 2012 15:01:44 -0500
Message-ID: <1351540908-12195-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351540908-12195-1-git-send-email-nm@ti.com>
References: <1351540908-12195-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new registration functions, governors can be now
registered with devfreq framework.

NOTE: generates 'discards qualifiers from pointer target type'
build warnings, which the next patche in this series fixes

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/governor_performance.c    |   18 ++++++++++++++++++
 drivers/devfreq/governor_powersave.c      |   18 ++++++++++++++++++
 drivers/devfreq/governor_simpleondemand.c |   18 ++++++++++++++++++
 drivers/devfreq/governor_userspace.c      |   18 ++++++++++++++++++
 4 files changed, 72 insertions(+)

diff --git a/drivers/devfreq/governor_performance.c b/drivers/devfreq/governor_performance.c
index eea3f9b..db8ff77 100644
--- a/drivers/devfreq/governor_performance.c
+++ b/drivers/devfreq/governor_performance.c
@@ -45,3 +45,21 @@ const struct devfreq_governor devfreq_performance = {
 	.get_target_freq = devfreq_performance_func,
 	.event_handler = devfreq_performance_handler,
 };
+
+static int __init devfreq_performance_init(void)
+{
+	return devfreq_add_governor(&devfreq_performance);
+}
+subsys_initcall(devfreq_performance_init);
+
+static void __exit devfreq_performance_exit(void)
+{
+	int ret;
+
+	ret = devfreq_remove_governor(&devfreq_performance);
+	if (ret)
+		pr_err("%s: failed remove governor %d\n", __func__, ret);
+
+	return;
+}
+module_exit(devfreq_performance_exit);
diff --git a/drivers/devfreq/governor_powersave.c b/drivers/devfreq/governor_powersave.c
index 2868d98..30f0fca 100644
--- a/drivers/devfreq/governor_powersave.c
+++ b/drivers/devfreq/governor_powersave.c
@@ -42,3 +42,21 @@ const struct devfreq_governor devfreq_powersave = {
 	.get_target_freq = devfreq_powersave_func,
 	.event_handler = devfreq_powersave_handler,
 };
+
+static int __init devfreq_powersave_init(void)
+{
+	return devfreq_add_governor(&devfreq_powersave);
+}
+subsys_initcall(devfreq_powersave_init);
+
+static void __exit devfreq_powersave_exit(void)
+{
+	int ret;
+
+	ret = devfreq_remove_governor(&devfreq_powersave);
+	if (ret)
+		pr_err("%s: failed remove governor %d\n", __func__, ret);
+
+	return;
+}
+module_exit(devfreq_powersave_exit);
diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
index b5cf0fb..85f9ed5 100644
--- a/drivers/devfreq/governor_simpleondemand.c
+++ b/drivers/devfreq/governor_simpleondemand.c
@@ -125,3 +125,21 @@ const struct devfreq_governor devfreq_simple_ondemand = {
 	.get_target_freq = devfreq_simple_ondemand_func,
 	.event_handler = devfreq_simple_ondemand_handler,
 };
+
+static int __init devfreq_simple_ondemand_init(void)
+{
+	return devfreq_add_governor(&devfreq_simple_ondemand);
+}
+subsys_initcall(devfreq_simple_ondemand_init);
+
+static void __exit devfreq_simple_ondemand_exit(void)
+{
+	int ret;
+
+	ret = devfreq_remove_governor(&devfreq_simple_ondemand);
+	if (ret)
+		pr_err("%s: failed remove governor %d\n", __func__, ret);
+
+	return;
+}
+module_exit(devfreq_simple_ondemand_exit);
diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index 7067555..110f178 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -140,3 +140,21 @@ const struct devfreq_governor devfreq_userspace = {
 	.get_target_freq = devfreq_userspace_func,
 	.event_handler = devfreq_userspace_handler,
 };
+
+static int __init devfreq_userspace_init(void)
+{
+	return devfreq_add_governor(&devfreq_userspace);
+}
+subsys_initcall(devfreq_userspace_init);
+
+static void __exit devfreq_userspace_exit(void)
+{
+	int ret;
+
+	ret = devfreq_remove_governor(&devfreq_userspace);
+	if (ret)
+		pr_err("%s: failed remove governor %d\n", __func__, ret);
+
+	return;
+}
+module_exit(devfreq_userspace_exit);
-- 
1.7.9.5

