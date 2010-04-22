Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab0DVT20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:26 -0400
Received: from kroah.org ([198.145.64.141]:40734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab0DVT2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:21 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:13 2010
Message-Id: <20100422190913.561269729@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [069/197] thinkpad-acpi: expose module parameters
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit b09c72259e88cec3d602aef987a3209297f3a9c2 upstream.

Export the normal (non-command) module paramenters as mode 0444, so
that they will show up in sysfs.

These parameters must not be changed at runtime as a rule, with very
few exceptions.

Reported-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8126,32 +8126,32 @@ static int __init set_ibm_param(const ch
 	return -EINVAL;
 }
 
-module_param(experimental, int, 0);
+module_param(experimental, int, 0444);
 MODULE_PARM_DESC(experimental,
 		 "Enables experimental features when non-zero");
 
 module_param_named(debug, dbg_level, uint, 0);
 MODULE_PARM_DESC(debug, "Sets debug level bit-mask");
 
-module_param(force_load, bool, 0);
+module_param(force_load, bool, 0444);
 MODULE_PARM_DESC(force_load,
 		 "Attempts to load the driver even on a "
 		 "mis-identified ThinkPad when true");
 
-module_param_named(fan_control, fan_control_allowed, bool, 0);
+module_param_named(fan_control, fan_control_allowed, bool, 0444);
 MODULE_PARM_DESC(fan_control,
 		 "Enables setting fan parameters features when true");
 
-module_param_named(brightness_mode, brightness_mode, uint, 0);
+module_param_named(brightness_mode, brightness_mode, uint, 0444);
 MODULE_PARM_DESC(brightness_mode,
 		 "Selects brightness control strategy: "
 		 "0=auto, 1=EC, 2=UCMS, 3=EC+NVRAM");
 
-module_param(brightness_enable, uint, 0);
+module_param(brightness_enable, uint, 0444);
 MODULE_PARM_DESC(brightness_enable,
 		 "Enables backlight control when 1, disables when 0");
 
-module_param(hotkey_report_mode, uint, 0);
+module_param(hotkey_report_mode, uint, 0444);
 MODULE_PARM_DESC(hotkey_report_mode,
 		 "used for backwards compatibility with userspace, "
 		 "see documentation");
@@ -8174,25 +8174,25 @@ TPACPI_PARAM(volume);
 TPACPI_PARAM(fan);
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
-module_param(dbg_wlswemul, uint, 0);
+module_param(dbg_wlswemul, uint, 0444);
 MODULE_PARM_DESC(dbg_wlswemul, "Enables WLSW emulation");
 module_param_named(wlsw_state, tpacpi_wlsw_emulstate, bool, 0);
 MODULE_PARM_DESC(wlsw_state,
 		 "Initial state of the emulated WLSW switch");
 
-module_param(dbg_bluetoothemul, uint, 0);
+module_param(dbg_bluetoothemul, uint, 0444);
 MODULE_PARM_DESC(dbg_bluetoothemul, "Enables bluetooth switch emulation");
 module_param_named(bluetooth_state, tpacpi_bluetooth_emulstate, bool, 0);
 MODULE_PARM_DESC(bluetooth_state,
 		 "Initial state of the emulated bluetooth switch");
 
-module_param(dbg_wwanemul, uint, 0);
+module_param(dbg_wwanemul, uint, 0444);
 MODULE_PARM_DESC(dbg_wwanemul, "Enables WWAN switch emulation");
 module_param_named(wwan_state, tpacpi_wwan_emulstate, bool, 0);
 MODULE_PARM_DESC(wwan_state,
 		 "Initial state of the emulated WWAN switch");
 
-module_param(dbg_uwbemul, uint, 0);
+module_param(dbg_uwbemul, uint, 0444);
 MODULE_PARM_DESC(dbg_uwbemul, "Enables UWB switch emulation");
 module_param_named(uwb_state, tpacpi_uwb_emulstate, bool, 0);
 MODULE_PARM_DESC(uwb_state,


