Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1DYXvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:51:51 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:42880 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757270Ab1DYXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:51:50 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB608EE.1060502@verizon.net>
Date: Mon, 25 Apr 2011 19:51:10 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>
Subject: [PATCH] kbuild: fix sed error in export_report.pl
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a sed error in export_report.pl by escaping a $.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/export_report.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/export_report.pl b/scripts/export_report.pl
index 04dce7c..91fa5a2 100644
--- a/scripts/export_report.pl
+++ b/scripts/export_report.pl
@@ -50,7 +50,7 @@ sub usage {
  sub collectcfiles {
     my @file
-	= `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko$/.mod.c/`;
+	= `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko\$/.mod.c/`;
     chomp @file;
     return @file;
 }
-- 
1.7.5.rc1

