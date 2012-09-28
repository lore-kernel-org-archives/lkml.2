Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422839Ab2I1VYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:24:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422757Ab2I1U3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        AceLan Kao <acelan.kao@canonical.com>,
        Matthew Garrett <mjg@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 153/218] asus-nb-wmi: add some video toggle keys
Date: Fri, 28 Sep 2012 13:16:10 -0700
Message-Id: <20120928201519.077609569@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/asus-nb-wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -94,6 +94,10 @@ static const struct key_entry asus_nb_wm
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


