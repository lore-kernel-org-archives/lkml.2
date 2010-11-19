Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab0KSWHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:07:10 -0500
Received: from kroah.org ([198.145.64.141]:53075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab0KSWEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:32 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:26 2010
Message-Id: <20101119220126.627271464@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: [54/66] asus-laptop: fix gps rfkill
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Corentin Chary <corentincj@iksaif.net>

commit 23f45c3a76e715217f40ac397c15815c774cad7f upstream.

The GPS rfkill crappy code. The ops_data argument wasn't
set, and was totally misused. The fix have been tested
on an Asus R2H.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/asus-laptop.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1065,9 +1065,9 @@ static ssize_t store_gps(struct device *
  */
 static int asus_gps_rfkill_set(void *data, bool blocked)
 {
-	acpi_handle handle = data;
+	struct asus_laptop *asus = data;
 
-	return asus_gps_switch(handle, !blocked);
+	return asus_gps_switch(asus, !blocked);
 }
 
 static const struct rfkill_ops asus_gps_rfkill_ops = {
@@ -1094,7 +1094,7 @@ static int asus_rfkill_init(struct asus_
 
 	asus->gps_rfkill = rfkill_alloc("asus-gps", &asus->platform_device->dev,
 					RFKILL_TYPE_GPS,
-					&asus_gps_rfkill_ops, NULL);
+					&asus_gps_rfkill_ops, asus);
 	if (!asus->gps_rfkill)
 		return -EINVAL;
 


