Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2ECJix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:38:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54268 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab2ECJiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:38:51 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] ideapad: generate valid key event only
Date: Thu,  3 May 2012 17:38:46 +0800
Message-Id: <1336037926-9987-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336037865-9918-1-git-send-email-ike.pan@canonical.com>
References: <1336037865-9918-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise will generate KEY_UNKNOWN on un-listed vpc event,
which means nothing and is hard for user to report the detail
of the event.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 00d82f1..4f20f8d 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -784,6 +784,10 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 			case 9:
 				ideapad_sync_rfk_state(priv);
 				break;
+			case 13:
+			case 6:
+				ideapad_input_report(priv, vpc_bit);
+				break;
 			case 4:
 				ideapad_backlight_notify_brightness(priv);
 				break;
@@ -794,7 +798,7 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 				ideapad_backlight_notify_power(priv);
 				break;
 			default:
-				ideapad_input_report(priv, vpc_bit);
+				pr_info("Unknown event: %lu\n", vpc_bit);
 			}
 		}
 	}
-- 
1.7.9.5

