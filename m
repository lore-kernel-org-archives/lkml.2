Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946258Ab2CPXzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:55:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45118 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032768Ab2CPXii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:38 -0400
Message-Id: <20120316233448.437458567@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>
Subject: [ 13/38] acer-wmi: Add wireless quirk for Lenovo 3000 N200
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit be3128b107e36271f7973ef213ccde603a494fe8 upstream.

This quirk fixes the wlan rfkill status on this machine. Without
it, wlan is permanently soft blocked whenever acer-wmi is loaded.

BugLink: https://bugs.launchpad.net/bugs/857297
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -463,6 +463,15 @@ static struct dmi_system_id acer_quirks[
 		},
 		.driver_data = &quirk_lenovo_ideapad_s205,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Lenovo 3000 N200",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "0687A31"),
+		},
+		.driver_data = &quirk_fujitsu_amilo_li_1718,
+	},
 	{}
 };
 


