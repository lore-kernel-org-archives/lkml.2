Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab1DZVoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:44:55 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:39544 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932131Ab1DZVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:44:49 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB73CA0.5080902@verizon.net>
Date: Tue, 26 Apr 2011 17:44:00 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3/4] kbuild: make includecheck work in KBUILD_OUTDIR
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the includecheck target so it works when make is invoked in KBUILD_OUTDIR.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 093c9d2..bfa0e90 100644
--- a/Makefile
+++ b/Makefile
@@ -1396,7 +1396,7 @@ tags TAGS cscope gtags: FORCE
 PHONY += includecheck versioncheck coccicheck namespacecheck export_report
  includecheck:
-	find * $(RCS_FIND_IGNORE) \
+	find $(srctree)/* $(RCS_FIND_IGNORE) \
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl
 -- 1.7.5.rc1

