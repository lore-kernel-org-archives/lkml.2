Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1CJX7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:59:38 -0500
Received: from kroah.org ([198.145.64.141]:46914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab1CJX5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.346174922@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Ivan Vecera <ivecera@redhat.com>, Hayes <hayeswang@realtek.com>
Subject: [patch 23/29] r8169: prevent RxFIFO induced loops in the irq handler.
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit f60ac8e7ab7cbb413a0131d5665b053f9f386526 upstream.

While the RxFIFO interruption is masked for most 8168, nothing prevents
it to appear in the irq status word. This is no excuse to crash.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Ivan Vecera <ivecera@redhat.com>
Cc: Hayes <hayeswang@realtek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4613,6 +4613,14 @@ static irqreturn_t rtl8169_interrupt(int
 				netif_stop_queue(dev);
 				rtl8169_tx_timeout(dev);
 				goto done;
+			/* Testers needed. */
+			case RTL_GIGA_MAC_VER_17:
+			case RTL_GIGA_MAC_VER_19:
+			case RTL_GIGA_MAC_VER_20:
+			case RTL_GIGA_MAC_VER_21:
+			case RTL_GIGA_MAC_VER_23:
+			case RTL_GIGA_MAC_VER_24:
+			case RTL_GIGA_MAC_VER_27:
 			/* Experimental science. Pktgen proof. */
 			case RTL_GIGA_MAC_VER_12:
 			case RTL_GIGA_MAC_VER_25:


