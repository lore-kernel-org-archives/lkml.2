Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2IQBAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:00:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33890 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200Ab2IQAvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:19 -0400
Message-Id: <20120917003632.350926689@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>
Subject: [ 044/135] Remove user-triggerable BUG from mpol_to_str
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a upstream.

Trivially triggerable, found by trinity:

  kernel BUG at mm/mempolicy.c:2546!
  Process trinity-child2 (pid: 23988, threadinfo ffff88010197e000, task ffff88007821a670)
  Call Trace:
    show_numa_map+0xd5/0x450
    show_pid_numa_map+0x13/0x20
    traverse+0xf2/0x230
    seq_read+0x34b/0x3e0
    vfs_read+0xac/0x180
    sys_pread64+0xa2/0xc0
    system_call_fastpath+0x1a/0x1f
  RIP: mpol_to_str+0x156/0x360

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index bd92431..4ada3be 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2562,7 +2562,7 @@ int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int no_context)
 		break;
 
 	default:
-		BUG();
+		return -EINVAL;
 	}
 
 	l = strlen(policy_modes[mode]);


