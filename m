Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab2JAXQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:16:03 -0400
Received: from 1wt.eu ([62.212.114.60]:35484 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab2JAXCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:01 -0400
Message-Id: <20121001225204.182914429@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, Willy Tarreau <w@1wt.eu>
Subject: [ 155/180] random: update interface comments to reflect reality
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit 442a4fffffa26fc3080350b4d50172f7589c3ac2 upstream.

At present, the comment header in random.c makes no mention of
add_disk_randomness, and instead, suggests that disk activity adds to the
random pool by way of add_interrupt_randomness, which appears to not have
been the case since sometime prior to the existence of git, and even prior
to bitkeeper. Didn't look any further back. At least, as far as I can
tell, there are no storage drivers setting IRQF_SAMPLE_RANDOM, which is a
requirement for add_interrupt_randomness to trigger, so the only way for a
disk to contribute entropy is by way of add_disk_randomness. Update
comments accordingly, complete with special mention about solid state
drives being a crappy source of entropy (see e2e1a148bc for reference).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a6e258b..de325792 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -128,6 +128,7 @@
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  * 	void add_interrupt_randomness(int irq);
+ * 	void add_disk_randomness(struct gendisk *disk);
  *
  * add_input_randomness() uses the input layer interrupt timing, as well as
  * the event type information from the hardware.
@@ -136,9 +137,15 @@
  * inputs to the entropy pool.  Note that not all interrupts are good
  * sources of randomness!  For example, the timer interrupts is not a
  * good choice, because the periodicity of the interrupts is too
- * regular, and hence predictable to an attacker.  Disk interrupts are
- * a better measure, since the timing of the disk interrupts are more
- * unpredictable.
+ * regular, and hence predictable to an attacker.  Network Interface
+ * Controller interrupts are a better measure, since the timing of the
+ * NIC interrupts are more unpredictable.
+ *
+ * add_disk_randomness() uses what amounts to the seek time of block
+ * layer request events, on a per-disk_devt basis, as input to the
+ * entropy pool. Note that high-speed solid state drives with very low
+ * seek times do not make for good sources of entropy, as their seek
+ * times are usually fairly consistent.
  *
  * All of these routines try to estimate how many bits of randomness a
  * particular randomness source.  They do this by keeping track of the
-- 
1.7.2.1.45.g54fbc



