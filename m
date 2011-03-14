Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1CNGws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 02:52:48 -0400
Received: from home.keithp.com ([63.227.221.253]:33790 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab1CNGwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 02:52:47 -0400
From: Keith Packard <keithp@keithp.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH] thinkpad-acpi: Some BIOS versions don't end in WW, remove check
Date: Sun, 13 Mar 2011 23:52:35 -0700
Message-Id: <1300085555-31022-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My X201s BIOS version string is 6QET46V1 (1.16 ). The
EC version string is 6QHT28WW-1.09. The driver was requiring that both
of these have 'WW' in positions 6 and 7. I don't know what the
significance of having 'V1' there instead is, but removing the test
makes the driver load on my machine.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index eb99223..32f602e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8617,8 +8617,7 @@ static bool __pure __init tpacpi_is_valid_fw_id(const char* const s,
 		tpacpi_is_fw_digit(s[1]) &&
 		s[2] == t && s[3] == 'T' &&
 		tpacpi_is_fw_digit(s[4]) &&
-		tpacpi_is_fw_digit(s[5]) &&
-		s[6] == 'W' && s[7] == 'W';
+		tpacpi_is_fw_digit(s[5]);
 }
 
 /* returns 0 - probe ok, or < 0 - probe error.
-- 
1.7.4.1

