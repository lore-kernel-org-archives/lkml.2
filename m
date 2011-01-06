Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1AFF3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 00:29:55 -0500
Received: from exht1.emulex.com ([138.239.113.183]:34007 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752467Ab1AFF3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 00:29:53 -0500
From: <Sathya.Perla@Emulex.Com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>, <stable@kernel.org>
CC: <stable-review@kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
        <subbu.seetharaman@Emulex.Com>, <Sarveshwar.Bandi@Emulex.Com>,
        <Ajit.Khaparde@Emulex.Com>, <joe.jin@oracle.com>,
        <davem@davemloft.net>
Date: Wed, 5 Jan 2011 21:29:23 -0800
Subject: RE: [064/152] driver/net/benet: fix be_cmd_multicast_set() memcpy
 bug
Thread-Topic: [064/152] driver/net/benet: fix be_cmd_multicast_set() memcpy
 bug
Thread-Index: AcutONlDS8s4JR7xQfOd5smV6tPwSAAKcMmw
Message-ID: <85ed0759-b208-4ee0-98a4-cdae0da5b430@exht1.ad.emulex.com>
References: <20110106002500.GA3172@kroah.com>
 <20110106002302.664621558@clark.site>
In-Reply-To: <20110106002302.664621558@clark.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below is fine. Thanks.

-Sathya

-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Thursday, January 06, 2011 5:53 AM
To: linux-kernel@vger.kernel.org; stable@kernel.org
Cc: stable-review@kernel.org; torvalds@linux-foundation.org; akpm@linux-foundation.org; alan@lxorguk.ukuu.org.uk; Perla, Sathya; Seetharaman, Subramanian; Bandi, Sarveshwar; Khaparde, Ajit; Joe Jin; David S. Miller
Subject: [064/152] driver/net/benet: fix be_cmd_multicast_set() memcpy bug

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Joe Jin <joe.jin@oracle.com>

[ Upstream commit 3fd40d0ceac9c234243730f4d7a6ffdb2fd3023a ]

Regarding  benet be_cmd_multicast_set() function, now using
netdev_for_each_mc_addr() helper for mac address copy, but
when copying to req->mac[] did not increase of the index.

Cc: Sathya Perla <sathyap@serverengines.com>
Cc: Subbu Seetharaman <subbus@serverengines.com>
Cc: Sarveshwar Bandi <sarveshwarb@serverengines.com>
Cc: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/benet/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/benet/be_cmds.c
+++ b/drivers/net/benet/be_cmds.c
@@ -1179,7 +1179,7 @@ int be_cmd_multicast_set(struct be_adapt
 
 		i = 0;
 		netdev_for_each_mc_addr(ha, netdev)
-			memcpy(req->mac[i].byte, ha->addr, ETH_ALEN);
+			memcpy(req->mac[i++].byte, ha->addr, ETH_ALEN);
 	} else {
 		req->promiscuous = 1;
 	}


