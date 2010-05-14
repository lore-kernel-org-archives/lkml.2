Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0ENQK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab0ENQKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:10:53 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] input: Add a PNP entry to the aux device list
Date: Fri, 14 May 2010 12:10:02 -0400
Message-Id: <1273853403-2870-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1273853403-2870-1-git-send-email-mjg@redhat.com>
References: <1273853403-2870-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.34.250
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows checks for an ALPS PS/2 device in PNP. Add it on the off-chance
that there's a machine that expresses this without also providing a
compatibility ID.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/input/serio/i8042-x86ia64io.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 871a74c..6168469 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -685,6 +685,7 @@ static struct pnp_driver i8042_pnp_kbd_driver = {
 };
 
 static struct pnp_device_id pnp_aux_devids[] = {
+	{ .id = "AUI0200", .driver_data = 0 },
 	{ .id = "FJC6000", .driver_data = 0 },
 	{ .id = "FJC6001", .driver_data = 0 },
 	{ .id = "PNP0f03", .driver_data = 0 },
-- 
1.7.0.1

