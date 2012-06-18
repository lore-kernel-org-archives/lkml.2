Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2FRPsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab2FRPsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:48:20 -0400
Date: Mon, 18 Jun 2012 11:48:17 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: output taint information when the rss-counter check trips up.
Message-ID: <20120618154817.GA7841@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had a couple reports of this happening, and it's tedious having
to spend a round trip asking "did you have 3rd party modules loaded".

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/kernel/fork.c b/kernel/fork.c
index ab5211b..0aa3c51 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -556,7 +556,7 @@ static void check_mm(struct mm_struct *mm)
 
 		if (unlikely(x))
 			printk(KERN_ALERT "BUG: Bad rss-counter state "
-					  "mm:%p idx:%d val:%ld\n", mm, i, x);
+					  "mm:%p idx:%d val:%ld (%s)\n", mm, i, x, print_tainted());
 	}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
