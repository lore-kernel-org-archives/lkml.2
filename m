Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab2ICAEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:04:24 -0400
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:44271 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755330Ab2ICADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:03:46 -0400
Subject: [PATCH 4/5] platform: x86: remove acpi_bus_generate_proc_event
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Harald Welte <laforge@gnumonks.org>,
        Mattia Dongili <malattia@linux.it>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: platform-driver-x86@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        acpi4asus-user@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 03 Sep 2012 02:03:31 +0200
Message-ID: <1346630611.3170.32.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling this function no longer makes sense as /proc/acpi/event
is being removed.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/platform/x86/asus-laptop.c      |    1 -
 drivers/platform/x86/eeepc-laptop.c     |    1 -
 drivers/platform/x86/fujitsu-laptop.c   |    4 ----
 drivers/platform/x86/panasonic-laptop.c |    2 --
 drivers/platform/x86/sony-laptop.c      |    3 ---
 drivers/platform/x86/thinkpad_acpi.c    |   11 -----------
 6 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index e38f91b..6c4e31d 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1514,7 +1514,6 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 
 	/* TODO Find a better way to handle events count. */
 	count = asus->event_count[event % 128]++;
-	acpi_bus_generate_proc_event(asus->device, event, count);
 	acpi_bus_generate_netlink_event(asus->device->pnp.device_class,
 					dev_name(&asus->device->dev), event,
 					count);
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index dab91b4..8a94d4d 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1267,7 +1267,6 @@ static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
 	if (event > ACPI_MAX_SYS_NOTIFY)
 		return;
 	count = eeepc->event_count[event % 128]++;
-	acpi_bus_generate_proc_event(device, event, count);
 	acpi_bus_generate_netlink_event(device->pnp.device_class,
 					dev_name(&device->dev), event,
 					count);
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index c4c1a54..2fac1c5 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -773,8 +773,6 @@ static void acpi_fujitsu_notify(struct acpi_device *device, u32 event)
 				else
 					set_lcd_level(newb);
 			}
-			acpi_bus_generate_proc_event(fujitsu->dev,
-				ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS, 0);
 			keycode = KEY_BRIGHTNESSUP;
 		} else if (oldb > newb) {
 			if (disable_brightness_adjust != 1) {
@@ -783,8 +781,6 @@ static void acpi_fujitsu_notify(struct acpi_device *device, u32 event)
 				else
 					set_lcd_level(newb);
 			}
-			acpi_bus_generate_proc_event(fujitsu->dev,
-				ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS, 0);
 			keycode = KEY_BRIGHTNESSDOWN;
 		}
 		break;
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 8e8caa7..a140e7f 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -465,8 +465,6 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 		return;
 	}
 
-	acpi_bus_generate_proc_event(pcc->device, HKEY_NOTIFY, result);
-
 	if (!sparse_keymap_report_event(hotk_input_dev,
 					result & 0xf, result & 0x80, false))
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index daaddec..5bfcfbc 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1269,8 +1269,6 @@ static void sony_nc_notify(struct acpi_device *device, u32 event)
 		sony_laptop_report_input_event(real_ev);
 	}
 
-	acpi_bus_generate_proc_event(sony_nc_acpi_device, ev_type, real_ev);
-
 	acpi_bus_generate_netlink_event(sony_nc_acpi_device->pnp.device_class,
 			dev_name(&sony_nc_acpi_device->dev), ev_type, real_ev);
 }
@@ -4100,7 +4098,6 @@ static irqreturn_t sony_pic_irq(int irq, void *dev_id)
 
 found:
 	sony_laptop_report_input_event(device_event);
-	acpi_bus_generate_proc_event(dev->acpi_dev, 1, device_event);
 	sonypi_compat_report_event(device_event);
 	return IRQ_HANDLED;
 }
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 80e3779..fb105fa 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2286,10 +2286,6 @@ static struct tp_acpi_drv_struct ibm_hotkey_acpidriver;
 static void tpacpi_hotkey_send_key(unsigned int scancode)
 {
 	tpacpi_input_send_key_masked(scancode);
-	if (hotkey_report_mode < 2) {
-		acpi_bus_generate_proc_event(ibm_hotkey_acpidriver.device,
-				0x80, TP_HKEY_EV_HOTKEY_BASE + scancode);
-	}
 }
 
 static void hotkey_read_nvram(struct tp_nvram_state *n, const u32 m)
@@ -3742,13 +3738,6 @@ static void hotkey_notify(struct ibm_struct *ibm, u32 event)
 				  "event happened to %s\n", TPACPI_MAIL);
 		}
 
-		/* Legacy events */
-		if (!ignore_acpi_ev &&
-		    (send_acpi_ev || hotkey_report_mode < 2)) {
-			acpi_bus_generate_proc_event(ibm->acpi->device,
-						     event, hkey);
-		}
-
 		/* netlink events */
 		if (!ignore_acpi_ev && send_acpi_ev) {
 			acpi_bus_generate_netlink_event(
-- 
1.7.4.1




