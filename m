Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2I1TEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:04:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030629Ab2I1TEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 213/262] gianfar: fix phc index build failure
Date: Fri, 28 Sep 2012 11:52:22 -0700
Message-Id: <20120928183023.267960426@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit 28889b7e7818342f6c254e27b9b2c68702ab867a upstream.

This patch fixes a build failure introduced in commit 66636287
("gianfar: Support the get_ts_info ethtool method."). Not only was a
global variable inconsistently named, but also it was not exported as
it should have been.

This fix is also needed in stable version 3.5.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/freescale/gianfar_ethtool.c |    1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c     |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1741,6 +1741,7 @@ static int gfar_get_nfc(struct net_devic
 }
 
 int gfar_phc_index = -1;
+EXPORT_SYMBOL(gfar_phc_index);
 
 static int gfar_get_ts_info(struct net_device *dev,
 			    struct ethtool_ts_info *info)
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -515,7 +515,7 @@ static int gianfar_ptp_probe(struct plat
 		err = PTR_ERR(etsects->clock);
 		goto no_clock;
 	}
-	gfar_phc_clock = ptp_clock_index(etsects->clock);
+	gfar_phc_index = ptp_clock_index(etsects->clock);
 
 	dev_set_drvdata(&dev->dev, etsects);
 
@@ -539,7 +539,7 @@ static int gianfar_ptp_remove(struct pla
 	gfar_write(&etsects->regs->tmr_temask, 0);
 	gfar_write(&etsects->regs->tmr_ctrl,   0);
 
-	gfar_phc_clock = -1;
+	gfar_phc_index = -1;
 	ptp_clock_unregister(etsects->clock);
 	iounmap(etsects->regs);
 	release_resource(etsects->rsrc);


