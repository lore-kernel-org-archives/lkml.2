Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0CaAnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:43:41 -0400
Received: from kroah.org ([198.145.64.141]:48353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0C3XIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:41 2010
Message-Id: <20100330224940.511762970@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [02/45] Fix potential crash with sys_move_pages
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1062,6 +1062,9 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 				goto out;
 
 			err = -ENODEV;
+			if (node < 0 || node >= MAX_NUMNODES)
+				goto out;
+
 			if (!node_state(node, N_HIGH_MEMORY))
 				goto out;
 


