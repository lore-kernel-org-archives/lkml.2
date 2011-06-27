Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1F0QfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:35:24 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50051 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1F0QfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rG+CQEV9zUIbyh2UIGEs9K9peVADQWY5lXVelh2LNW2/qpJZN3v+MMnUZb64Gc2Jub
         40fXe5cB3JIi1XR0jLSP29MeOfWHHyVkJqrO9XEpQFHNMPE1NIi9XYvz53yJseZSV8la
         L5Vx9tx71Uvocd9WbnAYaYEcYeulx9mCV4DE0=
Subject: [PATCH] treewide: fix kernel-doc warnings
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Cc: vitalivanov@gmail.com, Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 19:33:46 +0300
Message-ID: <1309192426.17574.47.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing 'make htmldocs' warnings:

Warning(/include/linux/hrtimer.h:153): No description found for parameter 'clockid'
Warning(/include/linux/device.h:604): Excess struct/union/enum/typedef member 'of_match' description in 'device'
Warning(/include/net/sock.h:349): Excess struct/union/enum/typedef member 'sk_rmem_alloc' description in 'sock'

Issue with:
Warning(/include/net/wimax.h:432): No description found for parameter 'rfkill_input'
is already solved in net-next tree -
commit #c6af9c406ceb3434281cf230938453931dcbab75 - net: wimax: Remove of unused 'rfkill_input' pointer.

Patch is against latest Linus' tree.

---
>From 55fe3701d1ed1f1302a73cd5bfdfc7972e89f5b7 Mon Sep 17 00:00:00 2001
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Mon, 27 Jun 2011 19:07:08 +0300
Subject: [PATCH] treewide: fix kernel-doc warnings

Fix 'make htmldocs' warnings:

Warning(/include/linux/hrtimer.h:153): No description found for
parameter 'clockid'
Warning(/include/linux/device.h:604): Excess struct/union/enum/typedef
member 'of_match' description in 'device'
Warning(/include/net/sock.h:349): Excess struct/union/enum/typedef
member 'sk_rmem_alloc' description in 'sock'

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 include/linux/device.h  |    1 -
 include/linux/hrtimer.h |    1 +
 include/net/sock.h      |    1 -
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 553fd37..e4f62d8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -530,7 +530,6 @@ struct device_dma_parameters {
  * @dma_mem:	Internal for coherent mem override.
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
- * @of_match:	Matching of_device_id from driver.
  * @devt:	For creating the sysfs "dev".
  * @devres_lock: Spinlock to protect the resource of the device.
  * @devres_head: The resources list of the device.
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 51932e5..fd0dc30 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -135,6 +135,7 @@ struct hrtimer_sleeper {
  * @cpu_base:		per cpu clock base
  * @index:		clock type index for per_cpu support when moving a
  *			timer to a base on another cpu.
+ * @clockid:		clock id for per_cpu support
  * @active:		red black tree root node for the active timers
  * @resolution:		the resolution of the clock, in nanoseconds
  * @get_time:		function to retrieve the current time of the clock
diff --git a/include/net/sock.h b/include/net/sock.h
index f2046e4..c0b938c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -178,7 +178,6 @@ struct sock_common {
   *	@sk_dst_cache: destination cache
   *	@sk_dst_lock: destination cache lock
   *	@sk_policy: flow policy
-  *	@sk_rmem_alloc: receive queue bytes committed
   *	@sk_receive_queue: incoming packets
   *	@sk_wmem_alloc: transmit queue bytes committed
   *	@sk_write_queue: Packet sending queue
-- 
1.7.0.4



