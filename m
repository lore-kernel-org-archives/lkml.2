Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab0JLRlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:41:11 -0400
Received: from p3plsmtpa01-09.prod.phx3.secureserver.net ([72.167.82.89]:59431
	"HELO p3plsmtpa01-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757306Ab0JLRlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:41:10 -0400
Message-ID: <4CB49EB3.6090000@sailtheuniverse.com>
Date: Tue, 12 Oct 2010 10:45:23 -0700
From: Hank Janssen <hjanssen@sailtheuniverse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: hjanssen@microsoft.com, Haiyang Zhang <haiyangz@microsoft.com>,
        gregkh@suse.de, virtualization@lists.osdl.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] staging: hv: Doubled ringbuffer size for Hyper-v network
 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hank Janssen <hjanssen@microsoft.com>

Double the default network ringsize buffer for Hyper-V network driver.
In very heavily loaded systems the there is a chance you run out of
ringbuffer space and error out.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 56e1157..45e082a 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -59,7 +59,7 @@ struct netvsc_driver_context {
 /* Need this many pages to handle worst case fragmented packet */
 #define PACKET_PAGES_HIWATER  (MAX_SKB_FRAGS + 2)
 
-static int ring_size = roundup_pow_of_two(2*MAX_SKB_FRAGS+1);
+static int ring_size = 128;
 module_param(ring_size, int, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
 
-- 
1.6.0.2


