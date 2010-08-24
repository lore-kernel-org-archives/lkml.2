Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0HXXKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:10:46 -0400
Received: from kroah.org ([198.145.64.141]:60974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933609Ab0HXXDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:17 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:08 2010
Message-Id: <20100824224508.631601905@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [085/114] e1000e: disable ASPM L1 on 82573
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit 19833b5dffe2f2e92a1b377f9aae9d5f32239512 upstream.

On the e1000-devel mailing list, Nils Faerber reported latency issues with
the 82573 LOM on a ThinkPad X60.  It was found to be caused by ASPM L1;
disabling it resolves the latency.  The issue is present in kernels back
to 2.6.34 and possibly 2.6.33.


Reported-by: Nils Faerber <nils.faerber@kernelconcepts.de>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/82571.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1833,6 +1833,7 @@ struct e1000_info e1000_82573_info = {
 				  | FLAG_HAS_SMART_POWER_DOWN
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_SWSM_ON_LOAD,
+	.flags2			= FLAG2_DISABLE_ASPM_L1,
 	.pba			= 20,
 	.max_hw_frame_size	= ETH_FRAME_LEN + ETH_FCS_LEN,
 	.get_variants		= e1000_get_variants_82571,


