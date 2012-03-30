Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935938Ab2C3VRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:17:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935907Ab2C3VQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:57 -0400
Message-Id: <20120330194826.759807374@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Daney <david.daney@cavium.com>,
        Florian Fainelli <florian@openwrt.org>
Subject: [ 007/175] staging/octeon: Fix PHY binding in octeon-ethernet driver.
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Daney <david.daney@cavium.com>

commit b5c19ca8014aa5151712274d5e70c3666a8918c1 upstream.

Commit d6c25be (mdio-octeon: use an unique MDIO bus name.) changed the
names used to refer to MDIO buses.  The ethernet driver must be
changed to match, so that the PHY drivers can be attached.

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/octeon/ethernet-mdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/octeon/ethernet-mdio.c
+++ b/drivers/staging/octeon/ethernet-mdio.c
@@ -164,9 +164,9 @@ int cvm_oct_phy_setup_device(struct net_
 
 	int phy_addr = cvmx_helper_board_get_mii_address(priv->port);
 	if (phy_addr != -1) {
-		char phy_id[20];
+		char phy_id[MII_BUS_ID_SIZE + 3];
 
-		snprintf(phy_id, sizeof(phy_id), PHY_ID_FMT, "0", phy_addr);
+		snprintf(phy_id, sizeof(phy_id), PHY_ID_FMT, "mdio-octeon-0", phy_addr);
 
 		priv->phydev = phy_connect(dev, phy_id, cvm_oct_adjust_link, 0,
 					PHY_INTERFACE_MODE_GMII);


