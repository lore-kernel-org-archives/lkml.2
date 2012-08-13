Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2HMUUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab2HMUU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Hung <alex.hung@canonical.com>, Matthew Garrett <mjg@redhat.com>
Subject: [ 05/82] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.
Date: Mon, 13 Aug 2012 13:18:41 -0700
Message-Id: <20120813201746.937383793@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

commit 63a78bb1051b240417daad3a3fa9c1bb10646dca upstream.

According to responses from the BIOS team, ASUS_WMI_METHODID_DSTS2
(0x53545344) will be used as future DSTS ID. In addition, calling
asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS2, 0, 0, NULL) returns
ASUS_WMI_UNSUPPORTED_METHOD in new ASUS laptop PCs. This patch fixes
no DSTS ID will be assigned in this case.

Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/asus-wmi.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1467,14 +1467,9 @@ static int asus_wmi_platform_init(struct
 	 */
 	if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS, 0, 0, NULL))
 		asus->dsts_id = ASUS_WMI_METHODID_DSTS;
-	else if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS2, 0, 0, NULL))
+	else
 		asus->dsts_id = ASUS_WMI_METHODID_DSTS2;
 
-	if (!asus->dsts_id) {
-		pr_err("Can't find DSTS");
-		return -ENODEV;
-	}
-
 	/* CWAP allow to define the behavior of the Fn+F2 key,
 	 * this method doesn't seems to be present on Eee PCs */
 	if (asus->driver->quirks->wapf >= 0)


