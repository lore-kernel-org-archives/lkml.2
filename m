Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2ETXYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 19:24:33 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:44686 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2ETXYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 19:24:32 -0400
Message-ID: <1337556268.3126.5.camel@lorien2>
Subject: [PATCH] x86: kernel/pci-calgary_64.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Cc: shuahkhan@gmail.com, x86@kernel.org, discuss@x86-64.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 20 May 2012 17:24:28 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change calgary_parse_options() to call kstrtoul() instead of calling
obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 arch/x86/kernel/pci-calgary_64.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index d0b2fb9..b72838b 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1480,8 +1480,9 @@ cleanup:
 static int __init calgary_parse_options(char *p)
 {
 	unsigned int bridge;
+	unsigned long val;
 	size_t len;
-	char* endp;
+	ssize_t ret;
 
 	while (*p) {
 		if (!strncmp(p, "64k", 3))
@@ -1512,10 +1513,11 @@ static int __init calgary_parse_options(char *p)
 				++p;
 			if (*p == '\0')
 				break;
-			bridge = simple_strtoul(p, &endp, 0);
-			if (p == endp)
+			ret = kstrtoul(p, 0, &val);
+			if (ret)
 				break;
 
+			bridge = val;
 			if (bridge < MAX_PHB_BUS_NUM) {
 				printk(KERN_INFO "Calgary: disabling "
 				       "translation for PHB %#x\n", bridge);
-- 
1.7.9.5



