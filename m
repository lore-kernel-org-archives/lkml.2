Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0J2For (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:44:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab0J2Fo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:44:27 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=SD_bTWQXDv0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=omOdbC7AAAAA:8 a=h1aNt0RaAAAA:8 a=meVymXHHAAAA:8 a=P7bmDZbWHMhsfyReHnEA:9 a=TIY8cTxmJGbAWhzvjfy5maWBzC8A:4 a=MSl-tDqOz04A:10 a=_RhRFcbxBZMA:10 a=9n0VZpmWo7gA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029054423.808049416@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 01:43:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Toralf Foerster <toralf.foerster@gmx.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hiromu Yakura <hiromu1996@gmail.com>
Subject: [PATCH 2/5] [PATCH 2/5] kconfig: Fix variable name typo %prompts in streamline_config.pl
References: <20101029054310.790179545@goodmis.org>
Content-Disposition: inline; filename=0002-kconfig-Fix-variable-name-typo-prompts-in-streamline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hiromu yagura <hiromu1996@gmail.com>

When I added "use strict;" to streamline_config.pl, I saw the following
warnings:

> Global symbol "%prompt" requires explicit package name at
scripts/kconfig/streamline_config.pl line 183.
> Global symbol "%prompt" requires explicit package name at
scripts/kconfig/streamline_config.pl line 368.

The declaration of %prompt was incorrect, and should have been %prompts.

Cc: Toralf Foerster <toralf.foerster@gmx.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
LKML-Reference: <1281845597.11566.5.camel@camp10-laptop>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index cc10bcf..3c63aa9 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -188,7 +188,7 @@ sub read_kconfig {
 	# configs without prompts must be selected
 	} elsif ($state ne "NONE" && /^\s*tristate\s\S/) {
 	    # note if the config has a prompt
-	    $prompt{$config} = 1;
+	    $prompts{$config} = 1;
 
 	# Check for if statements
 	} elsif (/^if\s+(.*\S)\s*$/) {
@@ -373,7 +373,7 @@ while ($repeat) {
 	    parse_config_dep_select $depends{$config};
 	}
 
-	if (defined($prompt{$config}) || !defined($selects{$config})) {
+	if (defined($prompts{$config}) || !defined($selects{$config})) {
 	    next;
 	}
 
-- 
1.7.1


