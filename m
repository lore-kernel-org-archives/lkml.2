Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2HGDqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:46:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964811Ab2HGDiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:54 -0400
Message-Id: <20120807032801.518224443@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Hung <alex.hung@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 37/70] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/asus-wmi.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1431,14 +1431,9 @@ static int asus_wmi_platform_init(struct
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
 	if (asus->driver->wapf >= 0)


