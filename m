Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab1DYXu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:50:57 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:42755 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757735Ab1DYXu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:50:56 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB608B1.9020201@verizon.net>
Date: Mon, 25 Apr 2011 19:50:09 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>
Subject: [PATCH] kbuild: allow includecheck and versioncheck to work in KBUILD_OUTPUT
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the includecheck and versioncheck targets
so they will work when make is run from KBUILD_OUTDIR.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 2a5159a..a105395 100644
--- a/Makefile
+++ b/Makefile
@@ -1395,12 +1395,12 @@ tags TAGS cscope gtags: FORCE
 PHONY += includecheck versioncheck coccicheck namespacecheck export_report
  includecheck:
-	find * $(RCS_FIND_IGNORE) \
+	find $(srctree)/* $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl
  versioncheck:
-	find * $(RCS_FIND_IGNORE) \
+	find $(srctree)/* $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
 -- 1.7.5.rc1

