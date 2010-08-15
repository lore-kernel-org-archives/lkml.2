Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785Ab0HOENY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 00:13:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62887 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0HOENX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 00:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=x0CeafSLuAz5S/x94juZ+RgOF1ZaBTwILs6z7HrpXs+UnlVG/y5kclViNpNI80mE5M
         fR+NIhYU+P1iz0cgv4W1ikqewyMzC8nmoVOLcYIyDzBbEWeqpVaMXUPKnYYxF6xCs4vw
         miL1xWZfU9KmTZfL5FYUeVJKqAtcHqYAmta9g=
Subject: [PATCH] kconfig: Fix variable name typo in streamline_config.pl.
From: hiromu yagura <hiromu1996@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Toralf Foerster <toralf.foerster@gmx.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Aug 2010 13:13:17 +0900
Message-ID: <1281845597.11566.5.camel@camp10-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I added "use strict;" to streamline_config.pl, I saw following
warnings.

> Global symbol "%prompt" requires explicit package name at
scripts/kconfig/streamline_config.pl line 183.
> Global symbol "%prompt" requires explicit package name at
scripts/kconfig/streamline_config.pl line 368.

Let's fix it.
(Note: prompts[] is defined at line 123 but never used. This seems
typo.)

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Toralf Foerster <toralf.foerster@gmx.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
---
 scripts/kconfig/streamline_config.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl
b/scripts/kconfig/streamline_config.pl
index c70a27d..d74363f 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -178,7 +178,7 @@ sub read_kconfig {
 	# configs without prompts must be selected
 	} elsif ($state ne "NONE" && /^\s*tristate\s\S/) {
 	    # note if the config has a prompt
-	    $prompt{$config} = 1;
+	    $prompts{$config} = 1;
 
 	# Check for if statements
 	} elsif (/^if\s+(.*\S)\s*$/) {
@@ -363,7 +363,7 @@ while ($repeat) {
 	    parse_config_dep_select $depends{$config};
 	}
 
-	if (defined($prompt{$config}) || !defined($selects{$config})) {
+	if (defined($prompts{$config}) || !defined($selects{$config})) {
 	    next;
 	}
 
-- 
1.7.0.4



