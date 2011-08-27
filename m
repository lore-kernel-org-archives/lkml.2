Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1H0NYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:24:41 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:41135 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab1H0NYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:24:39 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 6C2DE2D67A2
Subject: [PATCH 1/5] HID: roccat: Fixed false dpi reporting when using osd
 event
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Aug 2011 15:24:36 +0200
Message-ID: <1314451476.24216.72.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actual dpi resolution was set on wrong occassion.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 2b8f3a3..7847a5b 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -776,10 +776,10 @@ static void kone_keep_values_up_to_date(struct kone_device *kone,
 {
 	switch (event->event) {
 	case kone_mouse_event_switch_profile:
+		kone->actual_dpi = kone->profiles[event->value - 1].
+				startup_dpi;
 	case kone_mouse_event_osd_profile:
 		kone->actual_profile = event->value;
-		kone->actual_dpi = kone->profiles[kone->actual_profile - 1].
-				startup_dpi;
 		break;
 	case kone_mouse_event_switch_dpi:
 	case kone_mouse_event_osd_dpi:
-- 
1.7.3.4



