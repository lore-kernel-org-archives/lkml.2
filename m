Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1HLNcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1HLNc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:28 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 06/10] ktest: make start_monitor_and_boot true to its name
Date: Fri, 12 Aug 2011 15:32:08 +0200
Message-Id: <1313155932-20092-7-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull out the install parts of the monitor/boot function

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a42f8bf..4265652 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1164,11 +1164,13 @@ sub get_version {
     doprint "$version\n";
 }
 
-sub start_monitor_and_boot {
+sub grub_install {
     get_grub_index;
     get_version;
     install;
+}
 
+sub start_monitor_and_boot {
     start_monitor;
     return monitor;
 }
@@ -1494,6 +1496,7 @@ sub do_test {
     my ($type) = @_;
     my $failed = 0;
 
+    grub_install;
     start_monitor_and_boot or $failed = 1;
 
     if ($failed && $in_bisect && $type ne "boot") {
@@ -2615,6 +2618,7 @@ sub make_min_config {
 
 	my $failed = 0;
 	build "oldconfig";
+	grub_install;
 	start_monitor_and_boot or $failed = 1;
 	end_monitor;
 
-- 
1.7.4.1

