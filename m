Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3AEHqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 02:46:37 -0500
Received: from [216.228.121.35] ([216.228.121.35]:15068 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3AEHq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 02:46:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 Jan 2013 23:45:54 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 4/4] input: keyboard: tegra: remove default key mapping
Date: Sat, 5 Jan 2013 13:15:10 +0530
Message-ID: <1357371910-3164-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra KBC driver have the default key mapping for 16x8 configuration.
The key mapping can be provided through platform data or through DT
and the mapping varies from platform to platform, hence this default
mapping is not so useful. Remove the default mapping to reduce the code
lines of the driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- None

 drivers/input/keyboard/tegra-kbc.c |  156 +-----------------------------------
 1 files changed, 1 insertions(+), 155 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index ef7a0ac..c6e4985 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -87,147 +87,6 @@ struct tegra_kbc {
 	struct clk *clk;
 };
 
-static const u32 tegra_kbc_default_keymap[] = {
-	KEY(0, 2, KEY_W),
-	KEY(0, 3, KEY_S),
-	KEY(0, 4, KEY_A),
-	KEY(0, 5, KEY_Z),
-	KEY(0, 7, KEY_FN),
-
-	KEY(1, 7, KEY_LEFTMETA),
-
-	KEY(2, 6, KEY_RIGHTALT),
-	KEY(2, 7, KEY_LEFTALT),
-
-	KEY(3, 0, KEY_5),
-	KEY(3, 1, KEY_4),
-	KEY(3, 2, KEY_R),
-	KEY(3, 3, KEY_E),
-	KEY(3, 4, KEY_F),
-	KEY(3, 5, KEY_D),
-	KEY(3, 6, KEY_X),
-
-	KEY(4, 0, KEY_7),
-	KEY(4, 1, KEY_6),
-	KEY(4, 2, KEY_T),
-	KEY(4, 3, KEY_H),
-	KEY(4, 4, KEY_G),
-	KEY(4, 5, KEY_V),
-	KEY(4, 6, KEY_C),
-	KEY(4, 7, KEY_SPACE),
-
-	KEY(5, 0, KEY_9),
-	KEY(5, 1, KEY_8),
-	KEY(5, 2, KEY_U),
-	KEY(5, 3, KEY_Y),
-	KEY(5, 4, KEY_J),
-	KEY(5, 5, KEY_N),
-	KEY(5, 6, KEY_B),
-	KEY(5, 7, KEY_BACKSLASH),
-
-	KEY(6, 0, KEY_MINUS),
-	KEY(6, 1, KEY_0),
-	KEY(6, 2, KEY_O),
-	KEY(6, 3, KEY_I),
-	KEY(6, 4, KEY_L),
-	KEY(6, 5, KEY_K),
-	KEY(6, 6, KEY_COMMA),
-	KEY(6, 7, KEY_M),
-
-	KEY(7, 1, KEY_EQUAL),
-	KEY(7, 2, KEY_RIGHTBRACE),
-	KEY(7, 3, KEY_ENTER),
-	KEY(7, 7, KEY_MENU),
-
-	KEY(8, 4, KEY_RIGHTSHIFT),
-	KEY(8, 5, KEY_LEFTSHIFT),
-
-	KEY(9, 5, KEY_RIGHTCTRL),
-	KEY(9, 7, KEY_LEFTCTRL),
-
-	KEY(11, 0, KEY_LEFTBRACE),
-	KEY(11, 1, KEY_P),
-	KEY(11, 2, KEY_APOSTROPHE),
-	KEY(11, 3, KEY_SEMICOLON),
-	KEY(11, 4, KEY_SLASH),
-	KEY(11, 5, KEY_DOT),
-
-	KEY(12, 0, KEY_F10),
-	KEY(12, 1, KEY_F9),
-	KEY(12, 2, KEY_BACKSPACE),
-	KEY(12, 3, KEY_3),
-	KEY(12, 4, KEY_2),
-	KEY(12, 5, KEY_UP),
-	KEY(12, 6, KEY_PRINT),
-	KEY(12, 7, KEY_PAUSE),
-
-	KEY(13, 0, KEY_INSERT),
-	KEY(13, 1, KEY_DELETE),
-	KEY(13, 3, KEY_PAGEUP),
-	KEY(13, 4, KEY_PAGEDOWN),
-	KEY(13, 5, KEY_RIGHT),
-	KEY(13, 6, KEY_DOWN),
-	KEY(13, 7, KEY_LEFT),
-
-	KEY(14, 0, KEY_F11),
-	KEY(14, 1, KEY_F12),
-	KEY(14, 2, KEY_F8),
-	KEY(14, 3, KEY_Q),
-	KEY(14, 4, KEY_F4),
-	KEY(14, 5, KEY_F3),
-	KEY(14, 6, KEY_1),
-	KEY(14, 7, KEY_F7),
-
-	KEY(15, 0, KEY_ESC),
-	KEY(15, 1, KEY_GRAVE),
-	KEY(15, 2, KEY_F5),
-	KEY(15, 3, KEY_TAB),
-	KEY(15, 4, KEY_F1),
-	KEY(15, 5, KEY_F2),
-	KEY(15, 6, KEY_CAPSLOCK),
-	KEY(15, 7, KEY_F6),
-
-	/* Software Handled Function Keys */
-	KEY(20, 0, KEY_KP7),
-
-	KEY(21, 0, KEY_KP9),
-	KEY(21, 1, KEY_KP8),
-	KEY(21, 2, KEY_KP4),
-	KEY(21, 4, KEY_KP1),
-
-	KEY(22, 1, KEY_KPSLASH),
-	KEY(22, 2, KEY_KP6),
-	KEY(22, 3, KEY_KP5),
-	KEY(22, 4, KEY_KP3),
-	KEY(22, 5, KEY_KP2),
-	KEY(22, 7, KEY_KP0),
-
-	KEY(27, 1, KEY_KPASTERISK),
-	KEY(27, 3, KEY_KPMINUS),
-	KEY(27, 4, KEY_KPPLUS),
-	KEY(27, 5, KEY_KPDOT),
-
-	KEY(28, 5, KEY_VOLUMEUP),
-
-	KEY(29, 3, KEY_HOME),
-	KEY(29, 4, KEY_END),
-	KEY(29, 5, KEY_BRIGHTNESSDOWN),
-	KEY(29, 6, KEY_VOLUMEDOWN),
-	KEY(29, 7, KEY_BRIGHTNESSUP),
-
-	KEY(30, 0, KEY_NUMLOCK),
-	KEY(30, 1, KEY_SCROLLLOCK),
-	KEY(30, 2, KEY_MUTE),
-
-	KEY(31, 4, KEY_HELP),
-};
-
-static const
-struct matrix_keymap_data tegra_kbc_default_keymap_data = {
-	.keymap		= tegra_kbc_default_keymap,
-	.keymap_size	= ARRAY_SIZE(tegra_kbc_default_keymap),
-};
-
 static void tegra_kbc_report_released_keys(struct input_dev *input,
 					   unsigned short old_keycodes[],
 					   unsigned int old_num_keys,
@@ -701,26 +560,13 @@ static int tegra_kbd_setup_keymap(struct tegra_kbc *kbc)
 	const struct tegra_kbc_platform_data *pdata = kbc->pdata;
 	const struct matrix_keymap_data *keymap_data = pdata->keymap_data;
 	unsigned int keymap_rows = KBC_MAX_KEY;
-	int retval;
 
 	if (keymap_data && pdata->use_fn_map)
 		keymap_rows *= 2;
 
-	retval = matrix_keypad_build_keymap(keymap_data, NULL,
+	return matrix_keypad_build_keymap(keymap_data, NULL,
 					    keymap_rows, KBC_MAX_COL,
 					    kbc->keycode, kbc->idev);
-	if (retval == -ENOSYS || retval == -ENOENT) {
-		/*
-		 * If there is no OF support in kernel or keymap
-		 * property is missing, use default keymap.
-		 */
-		retval = matrix_keypad_build_keymap(
-					&tegra_kbc_default_keymap_data, NULL,
-					keymap_rows, KBC_MAX_COL,
-					kbc->keycode, kbc->idev);
-	}
-
-	return retval;
 }
 
 static int tegra_kbc_probe(struct platform_device *pdev)
-- 
1.7.1.1

