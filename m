Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab1D2Vlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:41:37 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:35868 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933899Ab1D2VlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:41:15 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB304D.3090703@verizon.net>
Date: Fri, 29 Apr 2011 17:40:29 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH RESEND 2/4] kbuild: make headerdep work in KBUILD_OUTDIR
Content-Type: multipart/mixed;
	boundary="------------080106080807080207080209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080106080807080207080209
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch fixes the headerdep target so it works when make is invoked
in KBUILD_OUTDIR.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 2a5159a..093c9d2 100644
--- a/Makefile
+++ b/Makefile
@@ -991,7 +991,8 @@ include/generated/utsrelease.h:
include/config/kernel.release FORCE

 PHONY += headerdep
 headerdep:
-	$(Q)find include/ -name '*.h' | xargs --max-args 1 scripts/headerdep.pl
+	$(Q)find $(srctree)/include/ -name '*.h' | xargs --max-args 1 \
+	$(srctree)/scripts/headerdep.pl -I$(srctree)/include

 #
---------------------------------------------------------------------------

-- 
1.7.5.rc1



--------------080106080807080207080209
Content-Type: text/plain;
	name="kbuild-make-headerdep-work-in-KBUILD_OUTDIR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-make-headerdep-work-in-KBUILD_OUTDIR.patch"

>From 547283fa29efcfbfecd2f277bf03a06d726bd294 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 17:17:11 -0400
Subject: [PATCH 2/4] kbuild: make headerdep work in KBUILD_OUTDIR


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 2a5159a..093c9d2 100644
--- a/Makefile
+++ b/Makefile
@@ -991,7 +991,8 @@ include/generated/utsrelease.h: include/config/kernel.release FORCE
 
 PHONY += headerdep
 headerdep:
-	$(Q)find include/ -name '*.h' | xargs --max-args 1 scripts/headerdep.pl
+	$(Q)find $(srctree)/include/ -name '*.h' | xargs --max-args 1 \
+	$(srctree)/scripts/headerdep.pl -I$(srctree)/include
 
 # ---------------------------------------------------------------------------
 
-- 
1.7.5.rc1



--------------080106080807080207080209--
