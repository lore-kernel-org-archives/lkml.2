Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab2K0HLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:11:19 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:48281 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758039Ab2K0HLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:11:18 -0500
Message-ID: <1354000267.3284.4.camel@thor>
Subject: [PATCH -next] staging/fwserial: Fix build breakage when !CONFIG_BUG
From: Peter Hurley <peter@hurleysoftware.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 Nov 2012 02:11:07 -0500
In-Reply-To: <50B3D767.70604@infradead.org>
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
	 <50B3D767.70604@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use WARN() as intended.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/dma_fifo.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/fwserial/dma_fifo.c b/drivers/staging/fwserial/dma_fifo.c
index 72aa053..5e84634 100644
--- a/drivers/staging/fwserial/dma_fifo.c
+++ b/drivers/staging/fwserial/dma_fifo.c
@@ -33,10 +33,7 @@
 
 #define FAIL(fifo, condition, format...) ({				\
 	fifo->corrupt = !!(condition);					\
-	if (unlikely(fifo->corrupt)) {					\
-		__WARN_printf(format);					\
-	}								\
-	unlikely(fifo->corrupt);					\
+	WARN(fifo->corrupt, format);					\
 })
 
 /*
-- 
1.8.0



