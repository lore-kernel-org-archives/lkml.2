Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2EFRL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:11:26 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31121 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2EFRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:11:09 -0400
Message-ID: <1336324264.2897.9.camel@lorien2>
Subject: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Borislav Petkov <bp@alien8.de>, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, tigran@aivazian.fsnet.co.uk
Cc: shuahkhan@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 06 May 2012 11:11:04 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change reload_for_cpu() in kernel/microcode_core.c to call kstrtoul()
instead of calling obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 arch/x86/kernel/microcode_core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

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
-- 
1.7.9.5



