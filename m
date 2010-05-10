Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab0EJXdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:33:21 -0400
Received: from kroah.org ([198.145.64.141]:33253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab0EJWwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:23 2010
Message-Id: <20100510223323.886078090@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Dillow <dave@thedillows.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [072/117] r8169: use correct barrier between cacheable and non-cacheable memory
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Dillow <dave@thedillows.org>

commit 4c020a961a812ffae9846b917304cea504c3a733 upstream.

r8169 needs certain writes to be visible to other CPUs or the NIC before
touching the hardware, but was using smp_wmb() which is only required to
order cacheable memory access. Switch to wmb() which is required to
order both cacheable and non-cacheable memory.

Noticed by Catalin Marinas and Paul Mackerras.

Signed-off-by: David Dillow <dave@thedillows.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4316,7 +4316,7 @@ static netdev_tx_t rtl8169_start_xmit(st
 
 	tp->cur_tx += frags + 1;
 
-	smp_wmb();
+	wmb();
 
 	RTL_W8(TxPoll, NPQ);	/* set polling bit */
 
@@ -4675,7 +4675,7 @@ static int rtl8169_poll(struct napi_stru
 		 * until it does.
 		 */
 		tp->intr_mask = 0xffff;
-		smp_wmb();
+		wmb();
 		RTL_W16(IntrMask, tp->intr_event);
 	}
 


