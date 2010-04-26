Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0DZU4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:56:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:34169 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0DZU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:56:53 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Michal Marek <mmarek@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH] Correctly deal with make that has an argument which contains an "s"
Date: Mon, 26 Apr 2010 15:56:14 -0500
Message-Id: <1272315374-11951-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 26 Apr 2010 20:56:38.0386 (UTC) FILETIME=[F6DFED20:01CAE582]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using remake, which is based on gnumake, if you invoke
an example build as shown below, the build will become silent
due to the top level make file incorrectly guessing that
the end user wants a silent build because an argument that
contained an "s" was used.

remake --no-extended-errors

Fix up the top level Makefile to use filter with a list of
options that mean silent with the various revisions of gnumake,
instead of findstring.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Michal Marek <mmarek@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kbuild@vger.kernel.org
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index fa1db90..91ae299 100644
--- a/Makefile
+++ b/Makefile
@@ -294,7 +294,7 @@ endif
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
 
-ifneq ($(findstring s,$(MAKEFLAGS)),)
+ifneq ($(filter s% -s% --silent --quiet,$(MAKEFLAGS)),)
   quiet=silent_
 endif
 
-- 
1.6.3.3

