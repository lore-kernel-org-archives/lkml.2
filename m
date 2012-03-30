Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab2C3VHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:07:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935162Ab2C3VHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:10 -0400
Message-Id: <20120330195733.371972421@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Krufky <mkrufky@linuxtv.org>,
        Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 078/108] [media] pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Krufky <mkrufky@linuxtv.org>

commit 9ab2393fc3e460cd2040de1483918eb17abb822f upstream.

The D1F5 revision of the WinTV HVR-1900 uses a tda18271c2 tuner
instead of a tda18271c1 tuner as used in revision D1E9. To
account for this, we must hardcode the frontend configuration
to use the same IF frequency configuration for both revisions
of the device.

6MHz DVB-T is unaffected by this issue, as the recommended
IF Frequency configuration for 6MHz DVB-T is the same on both
c1 and c2 revisions of the tda18271 tuner.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/pvrusb2/pvrusb2-devattr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/media/video/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
@@ -319,7 +319,17 @@ static struct tda829x_config tda829x_no_
 	.probe_tuner = TDA829X_DONT_PROBE,
 };
 
+static struct tda18271_std_map hauppauge_tda18271_dvbt_std_map = {
+        .dvbt_6   = { .if_freq = 3300, .agc_mode = 3, .std = 4,
+                      .if_lvl = 1, .rfagc_top = 0x37, },
+        .dvbt_7   = { .if_freq = 3800, .agc_mode = 3, .std = 5,
+                      .if_lvl = 1, .rfagc_top = 0x37, },
+        .dvbt_8   = { .if_freq = 4300, .agc_mode = 3, .std = 6,
+                      .if_lvl = 1, .rfagc_top = 0x37, },
+};
+
 static struct tda18271_config hauppauge_tda18271_dvb_config = {
+	.std_map = &hauppauge_tda18271_dvbt_std_map,
 	.gate    = TDA18271_GATE_ANALOG,
 	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };


