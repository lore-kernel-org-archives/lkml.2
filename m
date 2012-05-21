Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab2EUJrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:47:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2EUJrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:47:41 -0400
Date: Mon, 21 May 2012 02:47:24 -0700
From: tip-bot for Shuah Khan <shuahkhan@gmail.com>
Message-ID: <tip-74bc491795420254f8b9c782ec654c9ba005d3ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shuahkhan@gmail.com, muli@cs.technion.ac.il, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, muli@cs.technion.ac.il, tglx@linutronix.de
In-Reply-To: <1337556268.3126.5.camel@lorien2>
References: <1337556268.3126.5.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/pci-calgary_64.c:
  Remove obsoleted simple_strtoul() usage
Git-Commit-ID: 74bc491795420254f8b9c782ec654c9ba005d3ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:47:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74bc491795420254f8b9c782ec654c9ba005d3ac
Gitweb:     http://git.kernel.org/tip/74bc491795420254f8b9c782ec654c9ba005d3ac
Author:     Shuah Khan <shuahkhan@gmail.com>
AuthorDate: Sun, 20 May 2012 17:24:28 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 21 May 2012 10:29:40 +0200

x86/pci-calgary_64.c: Remove obsoleted simple_strtoul() usage

Change calgary_parse_options() to call kstrtoul() instead of
calling obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Acked-by: Muli Ben-Yehuda <muli@cs.technion.ac.il>
Cc: jdmason@kudzu.us
Link: http://lkml.kernel.org/r/1337556268.3126.5.camel@lorien2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/pci-calgary_64.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 6ac5782..dbbfb26 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1479,8 +1479,9 @@ cleanup:
 static int __init calgary_parse_options(char *p)
 {
 	unsigned int bridge;
+	unsigned long val;
 	size_t len;
-	char* endp;
+	ssize_t ret;
 
 	while (*p) {
 		if (!strncmp(p, "64k", 3))
@@ -1511,10 +1512,11 @@ static int __init calgary_parse_options(char *p)
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
