Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2DSHDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 03:03:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:55098 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab2DSHDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 03:03:18 -0400
Message-ID: <4F8FB8AD.3060102@iogearbox.net>
Date: Thu, 19 Apr 2012 09:03:09 +0200
From: Daniel Borkmann <danborkmann@iogearbox.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Ariane Keller <ariane.keller@tik.ee.ethz.ch>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xilinx_hwicap: reset XHI_MAX_RETRIES
References: <4F8F383C.1040002@iogearbox.net>
In-Reply-To: <4F8F383C.1040002@iogearbox.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: danborkmann@iogearbox.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset the XHI_MAX_RETRIES value. This allows the hardware enough time to
write configuration frames during partial reconfiguration. In case of 10
the driver returns an error, although it should just have polled the
register longer.

Tested on an ML605 board. The patch is against the latest linus-tree.

Signed-off-by: Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Signed-off-by: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.h b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
index 8cca119..d31ee23 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -86,7 +86,7 @@ struct hwicap_driver_config {
 };
 
 /* Number of times to poll the done regsiter */
-#define XHI_MAX_RETRIES     10
+#define XHI_MAX_RETRIES     5000
 
 /************ Constant Definitions *************/
 
