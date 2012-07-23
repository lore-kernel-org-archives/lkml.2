Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2GWBuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:50:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54391 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494Ab2GWBn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:26 -0400
Message-Id: <20120723010658.586361275@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>
Subject: [ 047/108] Remove easily user-triggerable BUG from generic_setlease
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit 8d657eb3b43861064d36241e88d9d61c709f33f0 upstream.

This can be trivially triggered from userspace by passing in something unexpected.

    kernel BUG at fs/locks.c:1468!
    invalid opcode: 0000 [#1] SMP
    RIP: 0010:generic_setlease+0xc2/0x100
    Call Trace:
      __vfs_setlease+0x35/0x40
      fcntl_setlease+0x76/0x150
      sys_fcntl+0x1c6/0x810
      system_call_fastpath+0x1a/0x1f

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 814c51d..fce6238 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1465,7 +1465,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	case F_WRLCK:
 		return generic_add_lease(filp, arg, flp);
 	default:
-		BUG();
+		return -EINVAL;
 	}
 }
 EXPORT_SYMBOL(generic_setlease);


