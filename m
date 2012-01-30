Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2A3WHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:07:07 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:47570 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab2A3WHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:07:05 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] hamradio: fix incompatible pointer in module parameter
Date: Mon, 30 Jan 2012 23:00:18 +0100
Message-Id: <1327960820-11867-15-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327961224;0e502121;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 'warning: return from incompatible pointer type' related
to module parameters.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/hamradio/baycom_epp.c |    2 +-
 drivers/net/hamradio/baycom_par.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 9537aaa..49b8b58 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -1162,7 +1162,7 @@ static void baycom_probe(struct net_device *dev)
 /*
  * command line settable parameters
  */
-static const char *mode[NR_PORTS] = { "", };
+static char *mode[NR_PORTS] = { "", };
 static int iobase[NR_PORTS] = { 0x378, };
 
 module_param_array(mode, charp, NULL, 0);
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 279d229..f1aea0c 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -477,7 +477,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 /*
  * command line settable parameters
  */
-static const char *mode[NR_PORTS] = { "picpar", };
+static char *mode[NR_PORTS] = { "picpar", };
 static int iobase[NR_PORTS] = { 0x378, };
 
 module_param_array(mode, charp, NULL, 0);
-- 
1.7.7.3

