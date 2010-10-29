Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0J2Foh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:44:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36667 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0J2FoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:44:25 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=9z3OAWccbyYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Zg5wBgmRkhVh7ym2aIwA:9 a=4aAQyYwHPD79neZ6dpCP1Ngu8OoA:4 a=jEp0ucaQiEUA:10 a=dtBAG6l0OysA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029054424.489445805@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 01:43:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 5/5] [PATCH 5/5] kconfig: Have streamline_config process menuconfigs too
References: <20101029054310.790179545@goodmis.org>
Content-Disposition: inline; filename=0005-kconfig-Have-streamline_config-process-menuconfigs-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Some menuconfigs in the Kconfig files have prompts and dependencies.
Currently, streamline_config misses these, and this can cause
streamline_config to keep modules enabled that should not be, and
even worse, not enable those that should.

This patch makes streamline_config process menuconfigs just like it
would process a config.

Reported-by: member graysky <graysky@archlinux.us>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index ebba407..fd81fc3 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -174,9 +174,9 @@ sub read_kconfig {
 	}
 
 	# configs found
-	if (/^\s*config\s+(\S+)\s*$/) {
+	if (/^\s*(menu)?config\s+(\S+)\s*$/) {
 	    $state = "NEW";
-	    $config = $1;
+	    $config = $2;
 
 	    for (my $i = 0; $i < $iflevel; $i++) {
 		if ($i) {
-- 
1.7.1


