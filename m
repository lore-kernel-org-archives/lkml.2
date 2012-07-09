Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2GIRg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:36:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34376 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab2GIRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:36:25 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 3/3] staging/slicoss: return -ENODEV if no devid matches
Date: Mon,  9 Jul 2012 23:04:20 +0530
Message-Id: <1341855260-9037-3-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
References: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if no case matches we are simply asserting and doing break.
and i think we may need to return that -ENODEV , no device is
present, rather assert'ing.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 5bd3825..56829fc 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3746,8 +3746,7 @@ static u32 slic_card_locate(struct adapter *adapter)
 		rdhostid_offset = SLIC_RDHOSTID_1GB;
 		break;
 	default:
-		ASSERT(0);
-		break;
+		return -ENODEV;
 	}
 
 	hostid_reg =
-- 
1.7.9.5

