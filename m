Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0HPQ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:28:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50861 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0HPQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:28:05 -0400
Date: Mon, 16 Aug 2010 18:28:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 12/16] drivers/platform/x86: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161827470.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

An error code is stored in ret, but the return value is always 0.  Return
ret instead.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics of the function and has not been tested.

 drivers/platform/x86/dell-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index b41ed5c..d4d6c9d 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -441,7 +441,7 @@ static int dell_send_intensity(struct backlight_device *bd)
 
 out:
 	release_buffer();
-	return 0;
+	return ret;
 }
 
 static int dell_get_intensity(struct backlight_device *bd)
