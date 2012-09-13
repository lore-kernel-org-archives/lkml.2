Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2IMUCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:02:47 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36782 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2IMUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:02:45 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] gmux: Fix backlight set function
Date: Thu, 13 Sep 2012 21:02:35 +0100
Message-Id: <1347566555-9388-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 7e30ed6b, "gmux: Add generic write32 function", the new
gmux_write32() function didn't include the io offset when writing
registers. This means that backlight update writes never go to the right
place. This patch fixes it.

Tested on Apple Macbook 8,3

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/apple-gmux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index dfb1a92..ee21056 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -101,7 +101,7 @@ static void gmux_pio_write32(struct apple_gmux_data *gmux_data, int port,
 
 	for (i = 0; i < 4; i++) {
 		tmpval = (val >> (i * 8)) & 0xff;
-		outb(tmpval, port + i);
+		outb(tmpval, gmux_data->iostart + port + i);
 	}
 }
 
-- 
1.7.9.5

