Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2IEHHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:07:41 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:36977 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2IEHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:07:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQDADj5RlBbdWObgWdsb2JhbABFhgW1ICIBARYmJ4IhAQUjDwFGEBkMAiYCAlcGE4gRqASTEYEhj2CBEgOVWZJ/
X-IronPort-AV: E=Sophos;i="4.80,372,1344204000"; 
   d="scan'208";a="1039034666"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net, devel@driverdev.osuosl.org
Subject: [PATCH] Staging: ipack: fix build failure in powerpc allyesconfig
Date: Wed,  5 Sep 2012 09:08:17 +0200
Message-Id: <1346828897-31783-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120905154801.b21cf25d96767b69489aec29@canb.auug.org.au>
References: <20120905154801.b21cf25d96767b69489aec29@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caused by commit 187e47824013 ("Staging: ipack: Read the ID space during
device registration").

drivers/staging/ipack/ipack.c: In function 'ipack_device_read_id':
drivers/staging/ipack/ipack.c:291:2: error: implicit declaration of function
	'ioread8' [-Werror=implicit-function-declaration]
drivers/staging/ipack/ipack.c:309:3: error: implicit declaration of function
	'ioread16be' [-Werror=implicit-function-declaration]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index da9e7bd..8cce6c4 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
+#include <asm/io.h>
 #include "ipack.h"
 
 #define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
-- 
1.7.10.4

