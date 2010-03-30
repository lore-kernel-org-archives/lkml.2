Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0C3XLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:11:44 -0400
Received: from kroah.org ([198.145.64.141]:48721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab0C3XLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:42 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:09 2010
Message-Id: <20100330225808.597715641@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [01/89] Fix potential crash with sys_move_pages
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6f5a55f1a6c5abee15a0e878e5c74d9f1569b8b0 upstream.

We incorrectly depended on the 'node_state/node_isset()' functions
testing the node range, rather than checking it explicitly.  That's not
reliable, even if it might often happen to work.  So do the proper
explicit test.

Reported-by: Marcus Meissner <meissner@suse.de>
Acked-and-tested-by: Brice Goglin <Brice.Goglin@inria.fr>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/migrate.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -937,6 +937,9 @@ static int do_pages_move(struct mm_struc
 				goto out_pm;
 
 			err = -ENODEV;
+			if (node < 0 || node >= MAX_NUMNODES)
+				goto out_pm;
+
 			if (!node_state(node, N_HIGH_MEMORY))
 				goto out_pm;
 


