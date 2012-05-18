Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030887Ab2ERC5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:57:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40569 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030728Ab2ERCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:51 -0400
Message-Id: <20120518023257.176824319@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 21/53] phy:icplus:fix Auto Power Saving in ip101a_config_init.
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

[ Upstream commit b3300146aa8efc5d3937fd33f3cfdc580a3843bc ]

This patch fixes Auto Power Saving configuration in ip101a_config_init
which was broken as there is no phy register write followed after
setting IP101A_APS_ON flag.

This patch also fixes the return value of ip101a_config_init.

Without this patch ip101a_config_init returns 2 which is not an error
accroding to IS_ERR and the mac driver will continue accessing 2 as
valid pointer to phy_dev resulting in memory fault.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/phy/icplus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index c81f136ae670..b14230016d9b 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -150,7 +150,8 @@ static int ip101a_config_init(struct phy_device *phydev)
 	/* Enable Auto Power Saving mode */
 	c = phy_read(phydev, IP10XX_SPEC_CTRL_STATUS);
 	c |= IP101A_APS_ON;
-	return c;
+
+	return phy_write(phydev, IP10XX_SPEC_CTRL_STATUS, c);
 }
 
 static int ip175c_read_status(struct phy_device *phydev)
-- 
1.7.10.1



