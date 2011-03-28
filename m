Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1C1SeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:34:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46344 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1C1SeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:34:00 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] asus-wmi: Enable autorepeat for hotkey input device
Date: Mon, 28 Mar 2011 13:33:44 -0500
Message-Id: <1301337224-3293-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
References: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
 <1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The T101MT Home/Express Gate key autorepeats in hardware, but
sparse-keymap does not support hardware autorepeat. Enable the
input core's software autorepeat to emulate the hardware behavior.
Normal hotkeys are autoreleased, so the behavior of these keys
will not be affected.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/asus-wmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index b14d992..0cb0fa7 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -205,6 +205,7 @@ static int asus_wmi_input_init(struct asus_wmi *asus)
 	asus->inputdev->phys = asus->driver->input_name;
 	asus->inputdev->id.bustype = BUS_HOST;
 	asus->inputdev->dev.parent = &asus->platform_device->dev;
+	__set_bit(EV_REP, asus->inputdev->evbit);
 
 	err = sparse_keymap_setup(asus->inputdev, asus->driver->keymap, NULL);
 	if (err)
-- 
1.7.4.1

