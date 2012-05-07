Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab2EGUue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:50:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab2EGUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:50:33 -0400
Date: Mon, 7 May 2012 13:49:55 -0700
From: tip-bot for Shuah Khan <shuahkhan@gmail.com>
Message-ID: <tip-e826abd523913f63eb03b59746ffb16153c53dc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de, bp@alien8.de,
        hpa@linux.intel.com
In-Reply-To: <1336324264.2897.9.camel@lorien2>
References: <1336324264.2897.9.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode: microcode_core.
 c simple_strtoul cleanup
Git-Commit-ID: e826abd523913f63eb03b59746ffb16153c53dc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 13:50:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e826abd523913f63eb03b59746ffb16153c53dc4
Gitweb:     http://git.kernel.org/tip/e826abd523913f63eb03b59746ffb16153c53dc4
Author:     Shuah Khan <shuahkhan@gmail.com>
AuthorDate: Sun, 6 May 2012 11:11:04 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 7 May 2012 11:36:49 -0700

x86, microcode: microcode_core.c simple_strtoul cleanup

Change reload_for_cpu() in kernel/microcode_core.c to call kstrtoul()
instead of calling obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Reviewed-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1336324264.2897.9.camel@lorien2
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_core.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index c9bda6d..fbdfc69 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -299,12 +299,11 @@ static ssize_t reload_store(struct device *dev,
 {
 	unsigned long val;
 	int cpu = dev->id;
-	int ret = 0;
-	char *end;
+	ssize_t ret = 0;
 
-	val = simple_strtoul(buf, &end, 0);
-	if (end == buf)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	if (val == 1) {
 		get_online_cpus();
