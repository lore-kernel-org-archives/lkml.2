Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab2JAXJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:09:48 -0400
Received: from 1wt.eu ([62.212.114.60]:35606 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab2JAXCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:55 -0400
Message-Id: <20121001225203.335423108@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 135/180] Remove user-triggerable BUG from mpol_to_str
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3c6e3e2..a6563fb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2259,7 +2259,7 @@ int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int no_context)
 		break;
 
 	default:
-		BUG();
+		return -EINVAL;
 	}
 
 	l = strlen(policy_types[mode]);
-- 
1.7.2.1.45.g54fbc



