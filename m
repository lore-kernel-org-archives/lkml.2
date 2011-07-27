Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1G0WMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:12:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:23542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab1G0VsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900318"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: dchang@novell.com, arjan.mels@gmx.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [4/99] staging: usbip: fix wrong endian conversion
Message-Id: <20110727214802.655872403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Chang <dchang@novell.com>

commit cacd18a8476ce145ca5dcd46dc5b75585fd1289c upstream.

Fix number_of_packets wrong endian conversion in function
correct_endian_ret_submit()

Signed-off-by: David Chang <dchang@novell.com>
Acked-by: Arjan Mels <arjan.mels@gmx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/usbip/usbip_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/staging/usbip/usbip_common.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/usbip_common.c
+++ linux-2.6.35.y/drivers/staging/usbip/usbip_common.c
@@ -709,7 +709,7 @@ static void correct_endian_ret_submit(st
 		be32_to_cpus(&pdu->status);
 		be32_to_cpus(&pdu->actual_length);
 		be32_to_cpus(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->number_of_packets);
 		be32_to_cpus(&pdu->error_count);
 	}
 }
