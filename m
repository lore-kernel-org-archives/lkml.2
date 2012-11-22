Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2KVSd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:33:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:49019 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab2KVSdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Igor Murzov <e-mail@date.by>, Sergey V <sftp.mtuci@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: [ 81/83] ACPI video: Ignore errors after _DOD evaluation.
Date: Wed, 21 Nov 2012 16:42:43 -0800
Message-Id: <20121122004221.293493645@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Murzov <e-mail@date.by>

commit fba4e087361605d1eed63343bb08811f097c83ee upstream.

There are systems where video module known to work fine regardless
of broken _DOD and ignoring returned value here doesn't cause
any issues later. This should fix brightness controls on some laptops.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47861

Signed-off-by: Igor Murzov <e-mail@date.by>
Reviewed-by: Sergey V <sftp.mtuci@gmail.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>

---
 drivers/acpi/video.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1345,12 +1345,15 @@ static int
 acpi_video_bus_get_devices(struct acpi_video_bus *video,
 			   struct acpi_device *device)
 {
-	int status;
+	int status = 0;
 	struct acpi_device *dev;
 
-	status = acpi_video_device_enumerate(video);
-	if (status)
-		return status;
+	/*
+	 * There are systems where video module known to work fine regardless
+	 * of broken _DOD and ignoring returned value here doesn't cause
+	 * any issues later.
+	 */
+	acpi_video_device_enumerate(video);
 
 	list_for_each_entry(dev, &device->children, node) {
 


