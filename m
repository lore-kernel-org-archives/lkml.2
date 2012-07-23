Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2GWCHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:07:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54011 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924Ab2GWBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:18 -0400
Message-Id: <20120723010653.199533104@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, William Dauchy <wdauchy@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 011/108] NFSv4: Rate limit the state manager for lock reclaim warning  messages
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Dauchy <wdauchy@gmail.com>

commit 96dcadc2fdd111dca90d559f189a30c65394451a upstream.

Adding rate limit on `Lock reclaim failed` messages since it could fill
up system logs
Signed-off-by: William Dauchy <wdauchy@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2: add the 'NFS:' prefix at the same time]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1261,8 +1261,9 @@ restart:
 				spin_lock(&state->state_lock);
 				list_for_each_entry(lock, &state->lock_states, ls_locks) {
 					if (!(lock->ls_flags & NFS_LOCK_INITIALIZED))
-						printk("%s: Lock reclaim failed!\n",
-							__func__);
+						pr_warn_ratelimited("NFS: "
+							"%s: Lock reclaim "
+							"failed!\n", __func__);
 				}
 				spin_unlock(&state->state_lock);
 				nfs4_put_open_state(state);



