Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2IYHeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:34:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43006 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2IYHeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:34:15 -0400
MIME-Version: 1.0
In-Reply-To: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
Date: Tue, 25 Sep 2012 10:34:13 +0300
X-Google-Sender-Auth: MvXOsRzysU_16unKe_8d-TZQfrg
Message-ID: <CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
Subject: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
From: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a patch to add support for Acer Aspire 5755G fan control
to acerhdf module for the latest BIOS version available in the Acer
web site, V1.20.

<DSDT disassembly dump>
...
Offset (0xA7),
OSTT,   8,
OSST,   8,
THLT,   8,
TCNL,   8,
MODE,   1,
    ,   2,
INIT,   1,
FAN1,   1,
FAN2,   1,
FANT,   1,
SKNM,   1,
SDTM,   8,
FSSN,   4,
FANU,   4,
...
</DSDT disassembly dump>

By experiment it was found that setting the register address 0xAB to
0x00 (FAN1 -> 0) caused the fan to stop, and setting it to the
original value of 0x08 (FAN1 -> 1) caused the fan to operate
automatically in BIOS control.

By observation the value in the Embedded Controller table which
correlated best with the temperature, and changes up and down along
with real temperature was the register address 0xB4 (SKTC).

This patch and related evidence and dumps were sent to the original
authors of the module, peter and bp.

The original author of the patch: Tero Keski-Valkama

Signed-off-by: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
---
 drivers/platform/x86/acerhdf.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 39abb15..06c5c85 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -7,6 +7,8 @@
  *                              http://piie.net
  *     2009 Borislav Petkov    bp (a) alien8.de
  *
+ *     2012 Tero Keski-Valkama  tero.keski-valkama (a) neter.fi
+ *
  * Inspired by and many thanks to:
  *  o acerfand   - Rachel Greenham
  *  o acer_ec.pl - Michael Kurz     michi.kurz (at) googlemail.com
@@ -187,6 +189,8 @@ static const struct bios_settings_t bios_tbl[] = {
        {"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
        {"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
        {"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
+       /* Acer 5755G */
+       {"Acer", "Aspire 5755G",  "V1.20", 0xab, 0xb4, {0x00, 0x08} },
        /* Acer 531 */
        {"Acer", "AO531h", "v0.3104", 0x55, 0x58, {0x20, 0x00} },
        {"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00} },
@@ -723,6 +727,7 @@ MODULE_ALIAS("dmi:*:*Acer*:pnAO751h*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1410*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1810*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1825PTZ:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*5755G:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
 MODULE_ALIAS("dmi:*:*Acer*:TravelMate*7730G:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
--
1.7.10.4
