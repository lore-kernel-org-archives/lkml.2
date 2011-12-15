Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab1LOOpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 09:45:51 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:45159 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab1LOOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 09:45:49 -0500
X-Greylist: delayed 3615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Dec 2011 09:45:49 EST
Date: Thu, 15 Dec 2011 08:40:36 -0500 (EST)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH V2] try to create KBUILD_OUTDIR automatically
Message-id: <alpine.LNX.2.00.1112150832360.61146@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to execute make O=/path/to/work instead of
mkdir -p /path/to/work
make O=/path/to/work

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---

V2:
update error message

 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index d1ea73f..5855399 100644
--- a/Makefile
+++ b/Makefile
@@ -115,11 +115,11 @@ $(CURDIR)/Makefile Makefile: ;
 
 ifneq ($(KBUILD_OUTPUT),)
 # Invoke a second make in the output directory, passing relevant variables
-# check that the output directory actually exists
+# check that the output directory exists or can be created
 saved-output := $(KBUILD_OUTPUT)
-KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
+KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && /bin/pwd)
 $(if $(KBUILD_OUTPUT),, \
-     $(error output directory "$(saved-output)" does not exist))
+     $(error output directory "$(saved-output)" does not exist and cannot be created))
 
 PHONY += $(MAKECMDGOALS) sub-make
 
-- 
1.7.8

