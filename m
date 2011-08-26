Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1HZB0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 21:26:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51984 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab1HZB0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 21:26:49 -0400
Date: Fri, 26 Aug 2011 11:26:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Gibson <dwg@au1.ibm.com>, jdl@jdl.com
Cc: Grant Likely <grant.likely@secretlab.ca>,
        John Bonesio <bones@secretlab.ca>, linux-kernel@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH] dtc: remove some warnings
Message-Id: <20110826112643.f86132d55edc5d452df3ebd0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume that these variables were used in the past but not removed when
their usage was removed.

Fixes these warnings:

scripts/dtc/dtc.c: In function 'main':
scripts/dtc/dtc.c:102:17: warning: variable 'check' set but not used [-Wunused-but-set-variable]
scripts/dtc/flattree.c: In function 'flat_read_mem_reserve':
scripts/dtc/flattree.c:700:14: warning: variable 'p' set but not used [-Wunused-but-set-variable]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/dtc/dtc.c      |    5 +----
 scripts/dtc/flattree.c |    2 --
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index cbc0193..fc83355 100644
--- a/scripts/dtc/dtc.c
+++ b/scripts/dtc/dtc.c
@@ -99,7 +99,7 @@ int main(int argc, char *argv[])
 	const char *inform = "dts";
 	const char *outform = "dts";
 	const char *outname = "-";
-	int force = 0, check = 0, sort = 0;
+	int force = 0, sort = 0;
 	const char *arg;
 	int opt;
 	FILE *outf = NULL;
@@ -137,9 +137,6 @@ int main(int argc, char *argv[])
 		case 'f':
 			force = 1;
 			break;
-		case 'c':
-			check = 1;
-			break;
 		case 'q':
 			quiet++;
 			break;
diff --git a/scripts/dtc/flattree.c b/scripts/dtc/flattree.c
index ead0332..28d0b23 100644
--- a/scripts/dtc/flattree.c
+++ b/scripts/dtc/flattree.c
@@ -697,7 +697,6 @@ static struct reserve_info *flat_read_mem_reserve(struct inbuf *inb)
 {
 	struct reserve_info *reservelist = NULL;
 	struct reserve_info *new;
-	const char *p;
 	struct fdt_reserve_entry re;
 
 	/*
@@ -706,7 +705,6 @@ static struct reserve_info *flat_read_mem_reserve(struct inbuf *inb)
 	 *
 	 * First pass, count entries.
 	 */
-	p = inb->ptr;
 	while (1) {
 		flat_read_chunk(inb, &re, sizeof(re));
 		re.address  = fdt64_to_cpu(re.address);
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
