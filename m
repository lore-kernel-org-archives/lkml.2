Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab1G1Xos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:62194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab1G1Xoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552528"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: ajay.gupta@ti.com, gadiyar@ti.com, balbi@ti.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [32/50] usb: musb: restore INDEX register in resume path
Message-Id: <20110728234436.D86D92403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ajay Kumar Gupta <ajay.gupta@ti.com>

[ upstream commit 3c5fec75e121b21a2eb35e5a6b44291509abba6f ]

Restoring the missing INDEX register value in musb_restore_context().
Without this suspend resume functionality is broken with offmode
enabled.

Cc: stable@kernel.org
Acked-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/usb/musb/musb_core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/musb/musb_core.c
+++ linux-2.6.35.y/drivers/usb/musb/musb_core.c
@@ -1697,6 +1697,7 @@ void musb_dma_completion(struct musb *mu
 			}
 		}
 	}
+	musb_writeb(musb_base, MUSB_INDEX, musb->context.index);
 }
 
 #else
