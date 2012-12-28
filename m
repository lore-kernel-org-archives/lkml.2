Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2L1TXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:23:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55707 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932470Ab2L1TT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:57 -0500
Message-Id: <20121228190336.275683941@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 030/173] powerpc: fix wii_memory_fixups() compile error on 3.0.y  tree
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

Fix wii_memory_fixups() the following compile error on 3.0.y tree with
wii_defconfig on 3.0.y tree.

  CC      arch/powerpc/platforms/embedded6xx/wii.o
arch/powerpc/platforms/embedded6xx/wii.c: In function ‘wii_memory_fixups’:
arch/powerpc/platforms/embedded6xx/wii.c:88:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘phys_addr_t’ [-Werror=format]
arch/powerpc/platforms/embedded6xx/wii.c:88:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Werror=format]
arch/powerpc/platforms/embedded6xx/wii.c:90:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘phys_addr_t’ [-Werror=format]
arch/powerpc/platforms/embedded6xx/wii.c:90:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Werror=format]
cc1: all warnings being treated as errors
make[2]: *** [arch/powerpc/platforms/embedded6xx/wii.o] Error 1
make[1]: *** [arch/powerpc/platforms/embedded6xx] Error 2
make: *** [arch/powerpc/platforms] Error 2

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/platforms/embedded6xx/wii.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 1b5dc1a..daf793b 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -85,9 +85,11 @@ void __init wii_memory_fixups(void)
 	wii_hole_start = p[0].base + p[0].size;
 	wii_hole_size = p[1].base - wii_hole_start;
 
-	pr_info("MEM1: <%08llx %08llx>\n", p[0].base, p[0].size);
+	pr_info("MEM1: <%08llx %08llx>\n",
+		(unsigned long long) p[0].base, (unsigned long long) p[0].size);
 	pr_info("HOLE: <%08lx %08lx>\n", wii_hole_start, wii_hole_size);
-	pr_info("MEM2: <%08llx %08llx>\n", p[1].base, p[1].size);
+	pr_info("MEM2: <%08llx %08llx>\n",
+		(unsigned long long) p[1].base, (unsigned long long) p[1].size);
 
 	p[0].size += wii_hole_size + p[1].size;
 


