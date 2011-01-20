Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1ATOqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:46:22 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:57781 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab1ATOqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:46:20 -0500
Subject: [PATCH] input: trackpoint: return proper error value
From: Davidlohr Bueso <dave@gnu.org>
To: Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>
Cc: linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 11:45:30 -0300
Message-ID: <1295534730.2089.1.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

If sysfs_create_group() returns an error, we should return it in trackpoint_detect(), instead of -1.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/input/mouse/trackpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 54b2fa8..e8b7c3f 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -324,7 +324,7 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 			error);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
-		return -1;
+		return error;
 	}
 
 	printk(KERN_INFO "IBM TrackPoint firmware: 0x%02x, buttons: %d/%d\n",
-- 
1.7.1



