Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2IIXfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:35:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51154 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776Ab2IIXQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:04 -0400
Message-Id: <20120909224203.287331185@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AceLan Kao <acelan.kao@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 93/95] asus-nb-wmi: add some video toggle keys
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit 3766054fff4af1b58a1440a284907887f4d2e8be upstream.

There are some new video switch keys that used by newer machines.
0xA0 - SDSP HDMI only
0xA1 - SDSP LCD + HDMI
0xA2 - SDSP CRT + HDMI
0xA3 - SDSP TV + HDMI
But in Linux, there is no suitable userspace application to handle this,
so, mapping them all to KEY_SWITCHVIDEOMODE.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/asus-nb-wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 57712ff..6b0ebde 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -192,6 +192,10 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x8A, { KEY_PROG1 } },
 	{ KE_KEY, 0x95, { KEY_MEDIA } },
 	{ KE_KEY, 0x99, { KEY_PHONE } },
+	{ KE_KEY, 0xA0, { KEY_SWITCHVIDEOMODE } }, /* SDSP HDMI only */
+	{ KE_KEY, 0xA1, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + HDMI */
+	{ KE_KEY, 0xA2, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + HDMI */
+	{ KE_KEY, 0xA3, { KEY_SWITCHVIDEOMODE } }, /* SDSP TV + HDMI */
 	{ KE_KEY, 0xb5, { KEY_CALC } },
 	{ KE_KEY, 0xc4, { KEY_KBDILLUMUP } },
 	{ KE_KEY, 0xc5, { KEY_KBDILLUMDOWN } },


