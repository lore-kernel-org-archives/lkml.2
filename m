Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1G0WCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:02:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:35829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab1G0Vsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900688"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: toby.gray@realvnc.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [48/99] USB: cdc-acm: Adding second ACM channel support for Nokia E7
Message-Id: <20110727214847.2F7882403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Toby Gray <toby.gray@realvnc.com>

commit 4061fde2fa80f40cb27114f60500d38d0afcf350 upstream.

This adds the Nokia E7 and C7 to the list of devices in cdc-acm, allowing
the secondary ACM channel on the device to be exposed. Without this patch
the ACM driver won't claim this secondary channel as it's marked as
having a vendor-specific protocol.

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/usb/class/cdc-acm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/class/cdc-acm.c
+++ linux-2.6.35.y/drivers/usb/class/cdc-acm.c
@@ -1619,6 +1619,8 @@ static const struct usb_device_id acm_id
 	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x0302), }, /* Nokia N8 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0335), }, /* Nokia E7 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x03cd), }, /* Nokia C7 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
