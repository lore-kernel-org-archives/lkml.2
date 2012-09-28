Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032963Ab2I1UrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:47:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44563 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032948Ab2I1UrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:47:03 -0400
X-Sasl-enc: NzysEVly4argT2CFvxOhneLYVZvMuNPok3PskJhN19g1 1348865223
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>, Dmitry Torokhov <dtor@mail.ru>
Subject: [ 061/127] Input: i8042 - disable mux on Toshiba C850D
Date: Fri, 28 Sep 2012 13:33:54 -0700
Message-Id: <20120928203052.981003096@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


