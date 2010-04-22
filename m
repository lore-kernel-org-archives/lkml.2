Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab0DVT6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:58:08 -0400
Received: from kroah.org ([198.145.64.141]:40769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab0DVT2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:24 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190913.929074655@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Josip Rodin <joy+kernel@entuzijast.net>,
       Len Brown <len.brown@intel.com>
Subject: [073/197] thinkpad-acpi: log initial state of rfkill switches
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 5451a923bbdcff6ae665947e120af7238b21a9d2 upstream.

We already log the initial state of the hardware rfkill switch (WLSW),
might as well log the state of the softswitches as well.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Josip Rodin <joy+kernel@entuzijast.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -1264,6 +1264,7 @@ static int __init tpacpi_new_rfkill(cons
 	struct tpacpi_rfk *atp_rfk;
 	int res;
 	bool sw_state = false;
+	bool hw_state;
 	int sw_status;
 
 	BUG_ON(id >= TPACPI_RFK_SW_MAX || tpacpi_rfkill_switches[id]);
@@ -1298,7 +1299,8 @@ static int __init tpacpi_new_rfkill(cons
 			rfkill_init_sw_state(atp_rfk->rfkill, sw_state);
 		}
 	}
-	rfkill_set_hw_state(atp_rfk->rfkill, tpacpi_rfk_check_hwblock_state());
+	hw_state = tpacpi_rfk_check_hwblock_state();
+	rfkill_set_hw_state(atp_rfk->rfkill, hw_state);
 
 	res = rfkill_register(atp_rfk->rfkill);
 	if (res < 0) {
@@ -1311,6 +1313,9 @@ static int __init tpacpi_new_rfkill(cons
 	}
 
 	tpacpi_rfkill_switches[id] = atp_rfk;
+
+	printk(TPACPI_INFO "rfkill switch %s: radio is %sblocked\n",
+		name, (sw_state || hw_state) ? "" : "un");
 	return 0;
 }
 


