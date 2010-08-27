Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0H0ENj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 00:13:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45985 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0H0ENf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 00:13:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52282783"
From: Saravana Kannan <skannan@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] pm_qos: Add system bus performance parameter
Date: Thu, 26 Aug 2010 21:13:23 -0700
Message-Id: <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers/devices might need some minimum system bus performance to
provide acceptable service. Provide a PM QoS parameter to send these requests
to.

The new parameter is named "system bus performance" since it is generic enough
for the unit of the request to be frequency, bandwidth or something else that
might be appropriate. It's up to each implementation of the QoS provider to
define what the unit of the request would be.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 kernel/pm_qos_params.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 996a4de..1a44a67 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -93,12 +93,21 @@ static struct pm_qos_object network_throughput_pm_qos = {
 	.type = PM_QOS_MAX,
 };
 
+static BLOCKING_NOTIFIER_HEAD(system_bus_performance_notifier);
+static struct pm_qos_object system_bus_performance_pm_qos = {
+	.requests = PLIST_HEAD_INIT(system_bus_performance_pm_qos.requests, pm_qos_lock),
+	.notifiers = &system_bus_performance_notifier,
+	.name = "system_bus_performance",
+	.default_value = 0,
+	.type = PM_QOS_MAX,
+};
 
 static struct pm_qos_object *pm_qos_array[] = {
 	&null_pm_qos,
 	&cpu_dma_pm_qos,
 	&network_lat_pm_qos,
 	&network_throughput_pm_qos
+	&system_bus_performance_pm_qos
 };
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
-- 
1.7.1.1
---
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
