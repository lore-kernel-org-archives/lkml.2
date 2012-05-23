Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab2EWN4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:56:36 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50434 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759743Ab2EWNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQV5EFFXBgESiBK6S4sYhTcDlRyJHoZSgmyBVA
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630131"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] Staging: ipack/bridges/tpci200: tpci200_slot_map_space() should return 0 if succeed.
Date: Wed, 23 May 2012 15:54:43 +0200
Message-Id: <1337781287-28628-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tpci200_slot_map_space() should return 0 if the operation was properly
done. If not, the caller will think that something wrong happened.

This patch establish the returned value to 0. It is overwritten in case of
error.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 85560c7..0c2a50a 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -628,7 +628,7 @@ static int tpci200_slot_unregister(struct ipack_device *dev)
 static int tpci200_slot_map_space(struct ipack_device *dev,
 				  unsigned int memory_size, int space)
 {
-	int res;
+	int res = 0;
 	unsigned int size_to_map;
 	void __iomem *phys_address;
 	struct ipack_addr_space *virt_addr_space;
-- 
1.7.10

