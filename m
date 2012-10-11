Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881Ab2JKCPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:15:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57330 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964898Ab2JKCPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:22 -0400
X-Sasl-enc: oTH1EGlqDc3ylncCC2oZew73xQ6sz/jmsH85EMdzpZKg 1349921720
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 65/84] r8169: increase the delay parameter of pm_schedule_suspend
Date: Thu, 11 Oct 2012 11:03:49 +0900
Message-Id: <20121011015428.760204781@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: hayeswang <hayeswang@realtek.com>

commit 10953db8e1a278742ef7e64a3d1491802bcfa98b upstream
The link down would occur when reseting PHY. And it would take about 2 ~ 5
seconds from link down to link up. If the delay of pm_schedule_suspend is
not long enough, the device would enter runtime_suspend before link up.
After link up, the device would wake up and reset PHY again. Then, you
would find the driver keep in a loop of runtime_suspend and rumtime_resume.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1157,7 +1157,7 @@ static void __rtl8169_check_link_status(
 		netif_carrier_off(dev);
 		netif_info(tp, ifdown, dev, "link down\n");
 		if (pm)
-			pm_schedule_suspend(&tp->pci_dev->dev, 100);
+			pm_schedule_suspend(&tp->pci_dev->dev, 5000);
 	}
 	spin_unlock_irqrestore(&tp->lock, flags);
 }


