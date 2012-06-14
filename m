Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab2FOACz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:02:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2FOAAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:44 -0400
Message-Id: <20120614235627.084485130@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [ 36/42] acpi_video: fix leaking PCI references
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit cfb46f433a4da97c31780e08a259fac2cb6bd61f upstream.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1745,6 +1745,7 @@ static int acpi_video_bus_remove(struct
 
 static int __init intel_opregion_present(void)
 {
+	int i915 = 0;
 #if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
 	struct pci_dev *dev = NULL;
 	u32 address;
@@ -1757,10 +1758,10 @@ static int __init intel_opregion_present
 		pci_read_config_dword(dev, 0xfc, &address);
 		if (!address)
 			continue;
-		return 1;
+		i915 = 1;
 	}
 #endif
-	return 0;
+	return i915;
 }
 
 int acpi_video_register(void)


