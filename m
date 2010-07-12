Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0GLW5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:57:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56985 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0GLW4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:36 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] staging: tidspbridge: fix build error for missing variable
Date: Mon, 12 Jul 2010 17:56:25 -0500
Message-Id: <1278975385-7769-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit:
staging: tidspbridge: gen: simplify and clean up
There is recently added hex_to_bin() kernel's method which we could use
instead of custom long function.

Introduced usage of hex_to_bin without defining the temp variable.
this causes the build error:
drivers/staging/tidspbridge/gen/uuidutil.c: In function 'uuid_hex_to_bin':
drivers/staging/tidspbridge/gen/uuidutil.c:63: error: 'value' undeclared (first use in this function)
drivers/staging/tidspbridge/gen/uuidutil.c:63: error: (Each undeclared identifier is reported only once
drivers/staging/tidspbridge/gen/uuidutil.c:63: error: for each function it appears in.)

introduce variable value to fix the error.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/gen/uuidutil.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
index eb09bc3..070761b 100644
--- a/drivers/staging/tidspbridge/gen/uuidutil.c
+++ b/drivers/staging/tidspbridge/gen/uuidutil.c
@@ -58,6 +58,7 @@ static s32 uuid_hex_to_bin(char *buf, s32 len)
 {
 	s32 i;
 	s32 result = 0;
+	int value;
 
 	for (i = 0; i < len; i++) {
 		value = hex_to_bin(*buf++);
-- 
1.6.3.3

