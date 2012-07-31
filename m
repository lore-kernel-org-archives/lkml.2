Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2GaEyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:54:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48850 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab2GaEvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:05 -0400
Message-Id: <20120731044316.425977832@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shuah Khan <shuahkhan@gmail.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 32/73] x86, microcode: microcode_core.c simple_strtoul cleanup
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuahkhan@gmail.com>

commit e826abd523913f63eb03b59746ffb16153c53dc4 upstream.

Change reload_for_cpu() in kernel/microcode_core.c to call kstrtoul()
instead of calling obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Reviewed-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1336324264.2897.9.camel@lorien2
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


