Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab0JHOQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:16:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab0JHOQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:16:35 -0400
Date: Fri, 8 Oct 2010 10:16:27 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ping Cheng <pinglinux@gmail.com>
Subject: [PATCH] wacom: fix pressure in Cintiq 21UX2
Message-ID: <20101008141627.GN341@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the pressure range in Cintiq 21UX2 is limited to half of the
supported. This patch fixes the problem.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 drivers/input/tablet/wacom_wac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linus-2.6.orig/drivers/input/tablet/wacom_wac.c	2010-09-22 14:52:22.000000000 -0400
+++ linus-2.6/drivers/input/tablet/wacom_wac.c	2010-10-07 17:20:30.000000000 -0400
@@ -442,7 +442,8 @@ static void wacom_intuos_general(struct 
 	/* general pen packet */
 	if ((data[1] & 0xb8) == 0xa0) {
 		t = (data[6] << 2) | ((data[7] >> 6) & 3);
-		if (features->type >= INTUOS4S && features->type <= INTUOS4L)
+		if (features->type >= INTUOS4S && features->type <= INTUOS4L ||
+		    features->type == WACOM_21UX2)
 			t = (t << 1) | (data[1] & 1);
 		input_report_abs(input, ABS_PRESSURE, t);
 		input_report_abs(input, ABS_TILT_X,
