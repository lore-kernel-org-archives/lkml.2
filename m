Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2JAO0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:26:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47667 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2JAOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:25:59 -0400
From: Yuta Ando <yuta.and@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Yuta Ando <yuta.and@gmail.com>
Subject: [PATCH] kconfig: Fix localyesconfig don't sets to 'yes'
Date: Mon,  1 Oct 2012 23:24:30 +0900
Message-Id: <1349101470-12243-1-git-send-email-yuta.and@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild target 'localyesconfig' has been same as 'localmodconfig'
since the commit 50bce3e "kconfig/streamline_config.pl: merge
local{mod,yes}config". The commit expects this script generates
different configure depending on target, but it was not yet implemented.

So I added code sets to 'yes' when target is 'localyesconfig'.

Signed-off-by: Yuta Ando <yuta.and@gmail.com>
---
 scripts/kconfig/streamline_config.pl |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 2fbbbc1..5eb3777 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -605,6 +605,8 @@ foreach my $line (@config_file) {
 	if (defined($configs{$1})) {
 	    if ($localyesconfig) {
 	        $setconfigs{$1} = 'y';
+		print "$1=y\n";
+		next;
 	    } else {
 	        $setconfigs{$1} = $2;
 	    }
-- 
1.7.3.4

