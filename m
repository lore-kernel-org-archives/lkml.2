Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2LMOrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:47:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab2LMOHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Engelthaler <engycz@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 104/241] mtd: slram: invalid checking of absolute end address
Date: Thu, 13 Dec 2012 11:57:49 -0200
Message-Id: <1355407206-17100-105-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Engelthaler <engycz@gmail.com>

commit c36a7ff4578ab6294885aef5ef241aeec4cdb1f0 upstream.

Fixed parsing end absolute address.

Signed-off-by: Jiri Engelthaler <engycz@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mtd/devices/slram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index 8f52fc8..5a5cd2a 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -240,7 +240,7 @@ static int parse_cmdline(char *devname, char *szstart, char *szlength)
 
 	if (*(szlength) != '+') {
 		devlength = simple_strtoul(szlength, &buffer, 0);
-		devlength = handle_unit(devlength, buffer) - devstart;
+		devlength = handle_unit(devlength, buffer);
 		if (devlength < devstart)
 			goto err_out;
 
-- 
1.7.9.5

