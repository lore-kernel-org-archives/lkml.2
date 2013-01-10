Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3AJIKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:10:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:13936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633Ab3AJIKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:10:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="244497300"
Subject: [PATCH] ST_CORE: Error triggered by convert "char" to "int"
From: channing <chao.bi@intel.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, pavan_savoy@ti.com
Cc: chuansheng.liu@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jan 2013 16:27:29 +0800
Message-ID: <1357806449.8296.32.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When st driver decodes protocol index received from raw data,
it does a value convert from "char" to "int". Because it's sign
extension from bit8 to bit32, the "int" value maybe minus, in
another word, the protocol index might be minus, but driver doesn't
filter such case and may continue access memory pointed by this
minus index.

This patch is to change the variable type of index from "int"
to "unsigned char", so that it avoids do such kind of type
conversion.

cc: liu chuansheng <chuansheng.liu@intel.com>
Signed-off-by: channing <chao.bi@intel.com>
---
 drivers/misc/ti-st/st_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index b90a224..0a14280 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -240,7 +240,8 @@ void st_int_recv(void *disc_data,
 	char *ptr;
 	struct st_proto_s *proto;
 	unsigned short payload_len = 0;
-	int len = 0, type = 0;
+	int len = 0;
+	unsigned char type = 0;
 	unsigned char *plen;
 	struct st_data_s *st_gdata = (struct st_data_s *)disc_data;
 	unsigned long flags;
-- 
1.7.1

