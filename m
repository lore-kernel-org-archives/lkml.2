Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab1D2Vlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:41:39 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:35882 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933917Ab1D2VlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:41:23 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DBB3056.7000106@verizon.net>
Date: Fri, 29 Apr 2011 17:40:38 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH RESEND 4/4] kbuild: make versioncheckcheck work in KBUILD_OUTDIR
Content-Type: multipart/mixed;
	boundary="------------030901050809030307090803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------030901050809030307090803
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch fixes the versioncheck target so it works when make is
invoked in KBUILD_OUTDIR.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index bfa0e90..56971f9 100644
--- a/Makefile
+++ b/Makefile
@@ -1401,7 +1401,7 @@ includecheck:
 		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl

 versioncheck:
-	find * $(RCS_FIND_IGNORE) \
+	find $(srctree)/* $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl

-- 
1.7.5.rc1



--------------030901050809030307090803
Content-Type: text/plain;
	name="kbuild-make-versioncheck-work-in-KBUILD_OUTDIR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-make-versioncheck-work-in-KBUILD_OUTDIR.patch"

>From 8b647ee346014ed4148ffd1887b30eb6f740f29b Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 17:19:28 -0400
Subject: [PATCH 4/4] kbuild: make versioncheck work in KBUILD_OUTDIR


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index bfa0e90..56971f9 100644
--- a/Makefile
+++ b/Makefile
@@ -1401,7 +1401,7 @@ includecheck:
 		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl
 
 versioncheck:
-	find * $(RCS_FIND_IGNORE) \
+	find $(srctree)/* $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
 
-- 
1.7.5.rc1



--------------030901050809030307090803--
