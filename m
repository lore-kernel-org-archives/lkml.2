Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358Ab2I1Veu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:34:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51449 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032546Ab2I1U1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>, Dmitry Torokhov <dtor@mail.ru>
Subject: [ 106/218] Input: i8042 - disable mux on Toshiba C850D
Date: Fri, 28 Sep 2012 13:15:23 -0700
Message-Id: <20120928201513.761813811@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit 8669cf6793bb38307a30fb6b9565ddc8840ebd3f upstream.

On Toshiba Satellite C850D, the touchpad and the keyboard might randomly
not work at boot. Preventing MUX mode activation solves this issue.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -335,6 +335,12 @@ static const struct dmi_system_id __init
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE C850D"),
+		},
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ALIENWARE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Sentia"),
 		},


