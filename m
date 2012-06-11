Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2FKDNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:13:45 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:10860 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2FKDNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:13:44 -0400
Message-ID: <1339384421.3025.8.camel@lorien2>
Subject: [PATCH] x86: kernel/cpu/perf_event.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: tglx@linutronix.de, hpa@zytor.com
Cc: shuahkhan@gmail.com, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jun 2012 21:13:41 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change set_attr_rdpmc() to call kstrtoul() instead of calling obsoleted
simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e049d6d..2e51c82f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1648,7 +1648,12 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	unsigned long val = simple_strtoul(buf, NULL, 0);
+	unsigned long val;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	if (!!val != !!x86_pmu.attr_rdpmc) {
 		x86_pmu.attr_rdpmc = !!val;
-- 
1.7.9.5



