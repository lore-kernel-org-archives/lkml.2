Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0HPVHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:07:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:34508 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab0HPVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:07:42 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] vt: fix regression warnings from KMS merge
Date: Mon, 16 Aug 2010 16:06:28 -0500
Message-Id: <1281992789-2471-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281992789-2471-4-git-send-email-jason.wessel@windriver.com>
References: <1281992789-2471-1-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-2-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-3-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Aug 2010 21:06:38.0135 (UTC) FILETIME=[EA9E5C70:01CB3D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following new sparse warnings in vt.c introduced by the commit
b45cfba4e9005d64d419718e7ff7f7cab44c1994 (vt,console,kdb: implement
atomic console enter/leave functions):

drivers/char/vt.c:197:5: warning: symbol 'saved_fg_console' was not declared. Should it be static?
drivers/char/vt.c:198:5: warning: symbol 'saved_last_console' was not declared. Should it be static?
drivers/char/vt.c:199:5: warning: symbol 'saved_want_console' was not declared. Should it be static?
drivers/char/vt.c:200:5: warning: symbol 'saved_vc_mode' was not declared. Should it be static?

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/vt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index c734f9b..3af1a22 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -194,10 +194,10 @@ static DECLARE_WORK(console_work, console_callback);
 int fg_console;
 int last_console;
 int want_console = -1;
-int saved_fg_console;
-int saved_last_console;
-int saved_want_console;
-int saved_vc_mode;
+static int saved_fg_console;
+static int saved_last_console;
+static int saved_want_console;
+static int saved_vc_mode;
 
 /*
  * For each existing display, we have a pointer to console currently visible
-- 
1.6.3.3

