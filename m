Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0HRPPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:15:24 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:58879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0HRPPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:15:22 -0400
Subject: [PATCH] firmware_class: fix typo in error path
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 17:15:18 +0200
Message-ID: <1282144518.5249.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In the error path, _request_firmware sets
firmware_p to NULL rather than *firmware_p,
which leads to passing a freed firmware
struct to drivers when the firmware file
cannot be found. Fix this.

Broken by commit f8a4bd3456b988fc73b2c.

Reported-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/base/firmware_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/base/firmware_class.c	2010-08-18 17:02:10.000000000 +0200
+++ wireless-testing/drivers/base/firmware_class.c	2010-08-18 17:13:43.000000000 +0200
@@ -568,7 +568,7 @@ static int _request_firmware(const struc
 out:
 	if (retval) {
 		release_firmware(firmware);
-		firmware_p = NULL;
+		*firmware_p = NULL;
 	}
 
 	return retval;


