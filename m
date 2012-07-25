Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab2GYTOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:14:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:26687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab2GYTOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:14:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186119138"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Pieper, Jeffrey E" <jeffrey.e.pieper@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Rick Jones <rick.jones2@hp.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH] igb: correct hardware type (i210/i211) check in
 igb_loopback_test()
Thread-Topic: [PATCH] igb: correct hardware type (i210/i211) check in
 igb_loopback_test()
Thread-Index: AQHNapiSF3r1AxmBl0euFYGkObEHDpc6XbYg
Date: Wed, 25 Jul 2012 19:13:36 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B62630D64753@ORSMSX102.amr.corp.intel.com>
References: <alpine.LNX.2.00.1207252059320.11754@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1207252059320.11754@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Jesper Juhl [mailto:jj@chaosbits.net] 
Sent: Wednesday, July 25, 2012 12:06 PM
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org; e1000-devel@lists.sourceforge.net; Wyborny, Carolyn; Pieper, Jeffrey E; Kirsher, Jeffrey T; Rick Jones; Ronciak, John; Brandeburg, Jesse; Allan, Bruce W; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter P; Duyck, Alexander H; David S. Miller
Subject: [PATCH] igb: correct hardware type (i210/i211) check in igb_loopback_test()

In the original code
...
 	if ((adapter->hw.mac.type == e1000_i210)
		|| (adapter->hw.mac.type == e1000_i210)) { ...
the second check of 'adapter->hw.mac.type' is pointless since it tests for the exact same value as the first.

After reading through a few other parts of the driver I believe that the second check was actually intended to check for 'e1000_i211'
rather than 'e1000_i210', but I admit that I'm not certain so someone with more knowledge about this driver should ACK the patch before it gets merged.

Unfortunately I have no hardware to actually test this on, so it is compile tested only.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index a19c84c..ad489b7 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1783,7 +1783,7 @@ static int igb_loopback_test(struct igb_adapter *adapter, u64 *data)
 		goto out;
 	}
 	if ((adapter->hw.mac.type == e1000_i210)
-		|| (adapter->hw.mac.type == e1000_i210)) {
+		|| (adapter->hw.mac.type == e1000_i211)) {
 		dev_err(&adapter->pdev->dev,
 			"Loopback test not supported "
 			"on this part at this time.\n");
--
1.7.11.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

ACK.

Good catch.  Thanks Jesper!

Carolyn

Carolyn Wyborny
Linux Development
LAN Access Division
Intel Corporation



