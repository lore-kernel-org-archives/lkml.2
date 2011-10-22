Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1JVPxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 11:53:19 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:33420 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1JVPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 11:53:18 -0400
X-Greylist: delayed 3615 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 11:53:18 EDT
Date: Sat, 22 Oct 2011 10:48:49 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH] kbuild: use xfwrite wrapper function to silence warnings
Message-id: <alpine.LNX.2.00.1110221045310.59156@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the xfwrite wrapper function defined in lkc.h to check the return value of
fwrite and silence these warnings.

  HOSTCC  scripts/kconfig/zconf.tab.o
scripts/kconfig/zconf.tab.c: In function 'header_print_comment':
/usr/src/lto/scripts/kconfig/confdata.c:551:10: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result
scripts/kconfig/zconf.tab.c: In function 'kconfig_print_comment':
/usr/src/lto/scripts/kconfig/confdata.c:467:10: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/confdata.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 59b667c..f90c22f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -464,7 +464,7 @@ kconfig_print_comment(FILE *fp, const char *value, void *arg)
 		fprintf(fp, "#");
 		if (l) {
 			fprintf(fp, " ");
-			fwrite(p, l, 1, fp);
+			xfwrite(p, l, 1, fp);
 			p += l;
 		}
 		fprintf(fp, "\n");
@@ -548,7 +548,7 @@ header_print_comment(FILE *fp, const char *value, void *arg)
 		fprintf(fp, " *");
 		if (l) {
 			fprintf(fp, " ");
-			fwrite(p, l, 1, fp);
+			xfwrite(p, l, 1, fp);
 			p += l;
 		}
 		fprintf(fp, "\n");
-- 
1.7.7

