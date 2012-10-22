Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab2JVHff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:35:35 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:12250 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2JVHfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:35:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAML2hFBbdWOb/2dsb2JhbABFwQuBCIIhAQVnEhAdNEkOBgESiAi6eJJOA5VxkDmCcQ
X-IronPort-AV: E=Sophos;i="4.80,628,1344204000"; 
   d="scan'208";a="585119330"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH] Staging: ipack/carriers: fix missing include linux/slab.h
Date: Mon, 22 Oct 2012 09:36:48 +0200
Message-Id: <1350891408-6755-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20121020110833.GF5714@localhost>
References: <20121020110833.GF5714@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel build failed for parisc architecture:

drivers/staging/ipack/carriers/tpci200.c: In function 'tpci200_free_irq':
drivers/staging/ipack/carriers/tpci200.c:190:2: error: implicit declaration of
function 'kfree' [-Werror=implicit-function-declaration]
drivers/staging/ipack/carriers/tpci200.c: In function 'tpci200_request_irq':
drivers/staging/ipack/carriers/tpci200.c:217:2: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/carriers/tpci200.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ipack/carriers/tpci200.c b/drivers/staging/ipack/carriers/tpci200.c
index 829fd1a..24e8e6d 100644
--- a/drivers/staging/ipack/carriers/tpci200.c
+++ b/drivers/staging/ipack/carriers/tpci200.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "tpci200.h"
 
 static const u16 tpci200_status_timeout[] = {
-- 
1.7.10.4

