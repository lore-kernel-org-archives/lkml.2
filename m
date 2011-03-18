Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1CRQTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:19:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51410 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab1CRQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:19:06 -0400
Date: Fri, 18 Mar 2011 09:18:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: manjunatha_halli@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH -next] drivers:media:radio: wl128x: fix printk format and
 text
Message-Id: <20110318091854.b234ad3e.randy.dunlap@oracle.com>
In-Reply-To: <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
	<1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
	<1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
	<1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D8385F2.000F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What happened to this driver in linux-next of 2011.0318?
It's in linux-next of 2011.0317.

Here's a patch that was prepared against linux-next of 2011.0317.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix text spacing and grammar.
Fix printk format warning:

drivers/media/radio/wl128x/fmdrv_common.c:274: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20110317.orig/drivers/media/radio/wl128x/fmdrv_common.c
+++ linux-next-20110317/drivers/media/radio/wl128x/fmdrv_common.c
@@ -271,8 +271,8 @@ static void recv_tasklet(unsigned long a
 	/* Process all packets in the RX queue */
 	while ((skb = skb_dequeue(&fmdev->rx_q))) {
 		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
-			fmerr("skb(%p) has only %d bytes"
-				"atleast need %d bytes to decode\n", skb,
+			fmerr("skb(%p) has only %d bytes; "
+				"need at least %zd bytes to decode\n", skb,
 				skb->len, sizeof(struct fm_event_msg_hdr));
 			kfree_skb(skb);
 			continue;
