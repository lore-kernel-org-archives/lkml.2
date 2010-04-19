Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0DSPh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:37:27 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:44377 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0DSPhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:37:25 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 11:37:25 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
CC: Hank Janssen <hjanssen@microsoft.com>,
       Toshikazu Sakai <Toshikazu.Sakai@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: Fix a bug affecting IPv6
Thread-Topic: [PATCH 1/1] Staging: hv: Fix a bug affecting IPv6
Thread-Index: AQHK39V8X4uWY3AUBkqHe8wd+ZPEBA==
Date: Mon, 19 Apr 2010 15:32:11 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266281C0D@TK5EX14MBXC121.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix a bug affecting IPv6
 Added the multicast flag for proper IPv6 function.
 Credits go to Toshikazu Sakai <toshikas@microsoft.com>

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Toshikazu Sakai <toshikas@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/RndisFilter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/RndisFilter.c b/drivers/staging/hv/RndisFilter.c
index cd2930d..6704f64 100644
--- a/drivers/staging/hv/RndisFilter.c
+++ b/drivers/staging/hv/RndisFilter.c
@@ -751,6 +751,7 @@ static int RndisFilterOpenDevice(struct rndis_device *Device)
 
 	ret = RndisFilterSetPacketFilter(Device,
 					 NDIS_PACKET_TYPE_BROADCAST |
+					 NDIS_PACKET_TYPE_ALL_MULTICAST |
 					 NDIS_PACKET_TYPE_DIRECTED);
 	if (ret == 0)
 		Device->State = RNDIS_DEV_DATAINITIALIZED;
-- 
1.6.3.2

