Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab2E0BI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:08:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab2E0BIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:08:48 -0400
Message-Id: <20120527010428.972090489@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:00 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shli@fusionio.com>,
        Holger Kiehl <Holger.Kiehl@dwd.de>, Hugh Dickins <hughd@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        William Dauchy <wdauchy@gmail.com>
Subject: [ 37/94] swap: dont do discard if no discard option added
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit 052b1987faca3606109d88d96bce124851f7c4c2 upstream.

When swapon() was not passed the SWAP_FLAG_DISCARD option, sys_swapon()
will still perform a discard operation.  This can cause problems if
discard is slow or buggy.

Reverse the order of the check so that a discard operation is performed
only if the sys_swapon() caller is attempting to enable discard.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Tested-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: William Dauchy <wdauchy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2103,7 +2103,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) == 0 && (swap_flags & SWAP_FLAG_DISCARD))
+		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
 			p->flags |= SWP_DISCARDABLE;
 	}
 


