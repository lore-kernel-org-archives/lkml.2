Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2AQPQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:16:21 -0500
Received: from mx2.gd-ms.com ([153.11.250.41]:54676 "EHLO mx2.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab2AQPQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:16:19 -0500
To: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Michael D Labriola <mlabriol@gdeb.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
MIME-Version: 1.0
Subject: [PATCH] x86, reboot: remove VersaLogic Menlow reboot quirk
X-KeepSent: 403557D6:D9E7AB81-85257988:00536641;
 type=4; name=$KeepSent
Message-ID: <OF403557D6.D9E7AB81-ON85257988.00536641-85257988.0053E284@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Tue, 17 Jan 2012 10:16:14 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-MESSAGE-ID: X-GDM-MESSAGE-ID mx2.gd-ms.com 1RnAlk-0007Fc-2k
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes the reboot quirk originally added by commit e19e074
(x86: Fix reboot problem on VersaLogic Menlow boards).

Testing with a VersaLogic Ocelot (VL-EPMs-21a rev 1.00 w/ BIOS 6.5.102)
revealed the following regarding the reboot hang problem:

- v2.6.37 reboot=bios was needed.

- v2.6.38-rc1: behavior changed, reboot=acpi is needed, reboot=kbd and
  reboot=bios result in system hang.

- v2.6.38: VersaLogic patch (e19e074 x86: Fix reboot problem on
  VersaLogic Menlow boards) was applied prior to v2.6.38-rc7.  This
  patch sets a quirk for VersaLogic Menlow boards that forces the use
  of reboot=bios, which doesn't work anymore.

- v3.2: It seems that commit 660e34c (x86: Reorder reboot method
  preferences) changed the default reboot method to acpi prior to
  v3.0-rc1, which means the default behavior is appropriate for the
  Ocelot.  No VersaLogic quirk is required.

The Ocelot board used for testing can successfully reboot w/out having to
pass any reboot= arguments for all 3 current versions of the BIOS.

Signed-off-by: Michael D Labriola <mlabriol@gdeb.com>
---
 arch/x86/kernel/reboot.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 4240d58..c584291 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -301,14 +301,6 @@ static struct dmi_system_id __initdata 
reboot_dmi_table[] = {
                        DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
                },
        },
-       {       /* Handle problems with rebooting on VersaLogic Menlow 
boards */
-               .callback = set_bios_reboot,
-               .ident = "VersaLogic Menlow based board",
-               .matches = {
-                       DMI_MATCH(DMI_BOARD_VENDOR, "VersaLogic 
Corporation"),
-                       DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow 
board"),
-               },
-       },
        { /* Handle reboot issue on Acer Aspire one */
                .callback = set_kbd_reboot,
                .ident = "Acer Aspire One A110",
-- 
1.6.0.3




 
