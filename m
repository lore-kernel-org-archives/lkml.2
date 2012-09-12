Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab2ILXrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:47:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2ILXpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:45:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 35/46] Remove user-triggerable BUG from mpol_to_str
Date: Wed, 12 Sep 2012 16:39:25 -0700
Message-Id: <20120912233821.338551227@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2500,7 +2500,7 @@ int mpol_to_str(char *buffer, int maxlen
 		break;
 
 	default:
-		BUG();
+		return -EINVAL;
 	}
 
 	l = strlen(policy_modes[mode]);


