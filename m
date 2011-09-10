Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1IJARQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:17:16 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:49474 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1IJARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:17:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1315613834!25037393!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] autofs4/root.c: quiet sparse noise
Date: Fri, 9 Sep 2011 17:17:02 -0700
User-Agent: KMail/1.9.9
CC: <autofs@linux.kernel.org>, <raven@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091717.02975.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function autofs4_d_manage is prototyped as a static function.
Add static to the function to quiet the sparse noise:

warning: symbol 'autofs4_d_manage' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Kent <raven@themaw.net>

---

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index f55ae23..366a9f2 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -427,7 +427,7 @@ done:
 	return NULL;
 }
 
-int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
+static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 
