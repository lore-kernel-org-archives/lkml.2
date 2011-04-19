Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1DSUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:25:58 -0400
Received: from kroah.org ([198.145.64.141]:35554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab1DSURR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201046.789176223@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Darren Hart <dvhart@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [34/70] futex: Set FLAGS_HAS_TIMEOUT during futex_wait restart setup
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit 0cd9c6494ee5c19aef085152bc37f3a4e774a9e1 upstream.

The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
restart futex_wait() without a timeout after a signal.

Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
of the restart block. Restore the originaly behavior.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922

Reported-by: Tim Smith <tsmith201104@yahoo.com>
Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Kacur <jkacur@redhat.com>
Link: http://lkml.kernel.org/r/%3Cdaac0eb3af607f72b9a4d3126b2ba8fb5ed3b883.1302820917.git.dvhart%40linux.intel.com%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1886,7 +1886,7 @@ retry:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = flags;
+	restart->futex.flags = flags | FLAGS_HAS_TIMEOUT;
 
 	ret = -ERESTART_RESTARTBLOCK;
 


