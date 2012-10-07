Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2JGX1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:27:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38675 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673Ab2JGXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:25 -0400
Message-Id: <20121007225839.405919649@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>, Dmitry Torokhov <dtor@mail.ru>
Subject: [ 034/108] Input: i8042 - disable mux on Toshiba C850D
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit 8669cf6793bb38307a30fb6b9565ddc8840ebd3f upstream.

On Toshiba Satellite C850D, the touchpad and the keyboard might randomly
not work at boot. Preventing MUX mode activation solves this issue.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/serio/i8042-x86ia64io.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 6918773..d6cc77a 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -335,6 +335,12 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
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


