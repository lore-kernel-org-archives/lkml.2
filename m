Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1AKXxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:53:33 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:34077 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab1AKXxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:53:30 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1294790006!10080043!9
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "cl@linux-foundation.org" <cl@linux-foundation.org>,
        "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
        "mpm@selenic.com" <mpm@selenic.com>
Date: Tue, 11 Jan 2011 17:49:32 -0600
Subject: [PATCH] mm/slab.c: make local symbols static
Thread-Topic: [PATCH] mm/slab.c: make local symbols static
Thread-Index: Acux6jGOmxL+N3vkQUqOPlJH49Z3JA==
Message-ID: <0D753D10438DA54287A00B027084269764CE0E54A2@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0BNrf21022756

Local symbols should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>

---

diff --git a/mm/slab.c b/mm/slab.c
index 2640374..37961d1f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -284,7 +284,7 @@ struct kmem_list3 {
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (3 * MAX_NUMNODES)
-struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
+static struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
 #define	SIZE_AC MAX_NUMNODES
 #define	SIZE_L3 (2 * MAX_NUMNODES)
@@ -4053,7 +4053,7 @@ static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
  * necessary. Note that the l3 listlock also protects the array_cache
  * if drain_array() is used on the shared array.
  */
-void drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
+static void drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
 			 struct array_cache *ac, int force, int node)
 {
 	int tofree;
@@ -4317,7 +4317,7 @@ static const struct seq_operations slabinfo_op = {
  * @count: data length
  * @ppos: unused
  */
-ssize_t slabinfo_write(struct file *file, const char __user * buffer,
+static ssize_t slabinfo_write(struct file *file, const char __user *buffer,
 		       size_t count, loff_t *ppos)
 {
 	char kbuf[MAX_SLABINFO_WRITE + 1], *tmp;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
