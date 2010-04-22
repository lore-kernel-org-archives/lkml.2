Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0DVT3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:51 -0400
Received: from kroah.org ([198.145.64.141]:41361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0DVT31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:27 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:20 2010
Message-Id: <20100422190920.465815919@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       maximilian attems <max@stro.at>
Subject: [147/197] b43: Remove reset after fatal DMA error
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 214ac9a4ead6cb254451c09d9c8234a76693feb1 upstream.

As shown in Kernel Bugzilla #14761, doing a controller restart after a
fatal DMA error does not accomplish anything other than consume the CPU
on an affected system. Accordingly, substitute a meaningful message for
the restart.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1788,7 +1788,10 @@ static void b43_do_interrupt_thread(stru
 			       dma_reason[0], dma_reason[1],
 			       dma_reason[2], dma_reason[3],
 			       dma_reason[4], dma_reason[5]);
-			b43_controller_restart(dev, "DMA error");
+			b43err(dev->wl, "This device does not support DMA "
+			       "on your system. Please use PIO instead.\n");
+			b43err(dev->wl, "CONFIG_B43_FORCE_PIO must be set in "
+			       "your kernel configuration.\n");
 			return;
 		}
 		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {


