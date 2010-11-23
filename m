Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0KWTlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:41:21 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47373 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751930Ab0KWTlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:41:19 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v4 5/5] da850-evm: KEYBOARD_GPIO and INPUT_POLLDEV Kconfig conditionals
Date: Tue, 23 Nov 2010 14:41:00 -0500
Message-Id: <3f75a5067091aebdac52d2b0d8788abe5dddbfb0.1290540916.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1290540916.git.bengardiner@nanometrics.ca>
References: <cover.1290201713.git.bengardiner@nanometrics.ca> <cover.1290540916.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the mach-davinci/Kconfig to enable gpio-keys as default when da850-evm
machine is enabled and to also select INPUT_POLLDEV when gpio-keys is enabled.

INPUT_POLLDEV needs to be enabled for gpio-keys devices to function properly
on da850-evm.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: "Nori, Sekhar" <nsekhar@ti.com>

---

Changes since v3:
 * no changes in this patch of the series / this patch was introduced in v4 of
   the series

---
 arch/arm/mach-davinci/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 84066e8..70d1758 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -180,6 +180,10 @@ endchoice
 config GPIO_PCA953X
 	default MACH_DAVINCI_DA850_EVM
 
+config KEYBOARD_GPIO
+	default MACH_DAVINCI_DA850_EVM
+	select INPUT_POLLDEV if MACH_DAVINCI_DA850_EVM
+
 config MACH_TNETV107X
 	bool "TI TNETV107X Reference Platform"
 	default ARCH_DAVINCI_TNETV107X
-- 
1.7.0.4

