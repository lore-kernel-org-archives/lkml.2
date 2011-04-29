Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab1D2WjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:39:22 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:51390 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934024Ab1D2WjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:39:19 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3DEB.9050402@verizon.net>
Date: Fri, 29 Apr 2011 18:38:35 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH V2 5/7] kbuild: update scripts/Makefile in preperation for
 moving docproc
Content-Type: multipart/mixed;
	boundary="------------040201050400070403020403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------040201050400070403020403
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch updates scripts/Makefile in preperation for moving docproc.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile b/scripts/Makefile
index fcea261..df7678f 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -6,6 +6,7 @@
 # pnmttologo:    Convert pnm files to logo files
 # conmakehash:   Create chartable
 # conmakehash:	 Create arrays for initializing the kernel console tables
+# docproc:       Used in Documentation/DocBook

 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
@@ -16,12 +17,14 @@ hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 always		:= $(hostprogs-y) $(hostprogs-m)

 # The following hostprogs-y programs are only build on demand
-hostprogs-y += unifdef
+hostprogs-y += unifdef docproc

-# This target is used internally to avoid "is up to date" messages
+# These targets are used internally to avoid "is up to date" messages
 PHONY += build_unifdef
 build_unifdef: scripts/unifdef FORCE
 	@:
+build_docproc: scripts/docproc FORCE
+	@:

 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
-- 
1.7.5.rc1



--------------040201050400070403020403
Content-Type: text/plain;
	name="kbuild-update-scripts-Makefile-in-preperation-for-mo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-update-scripts-Makefile-in-preperation-for-mo.patch"

>From 0672aebb7e5ab225830e2035b4a7d61d8cf59e84 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 19:24:06 -0400
Subject: [PATCH 5/7] kbuild: update scripts/Makefile in preperation for moving docproc


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile b/scripts/Makefile
index fcea261..df7678f 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -6,6 +6,7 @@
 # pnmttologo:    Convert pnm files to logo files
 # conmakehash:   Create chartable
 # conmakehash:	 Create arrays for initializing the kernel console tables
+# docproc:       Used in Documentation/DocBook
 
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
@@ -16,12 +17,14 @@ hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 always		:= $(hostprogs-y) $(hostprogs-m)
 
 # The following hostprogs-y programs are only build on demand
-hostprogs-y += unifdef
+hostprogs-y += unifdef docproc
 
-# This target is used internally to avoid "is up to date" messages
+# These targets are used internally to avoid "is up to date" messages
 PHONY += build_unifdef
 build_unifdef: scripts/unifdef FORCE
 	@:
+build_docproc: scripts/docproc FORCE
+	@:
 
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
-- 
1.7.5.rc1



--------------040201050400070403020403--
