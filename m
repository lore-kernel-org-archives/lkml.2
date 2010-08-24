Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab0HXXTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:19:47 -0400
Received: from kroah.org ([198.145.64.141]:40969 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381Ab0HXXBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:54 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:04 2010
Message-Id: <20100824224504.066419792@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [032/114] drm/radeon/kms: add missing copy from user
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dr. David Alan Gilbert <linux@treblig.org>

commit d8ab35575098b2d6dc10b2535aeb40545933ae56 upstream.

This hasn't mattered up until the ioctl started using the value, and it fell
apart.

fixes fd.o 29340, Ubuntu LP 606081

[airlied: cleaned up whitespace and don't need an error before pushing]

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_kms.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -106,7 +106,9 @@ int radeon_info_ioctl(struct drm_device
 
 	info = data;
 	value_ptr = (uint32_t *)((unsigned long)info->value);
-	value = *value_ptr;
+	if (DRM_COPY_FROM_USER(&value, value_ptr, sizeof(value)))
+		return -EFAULT;
+
 	switch (info->request) {
 	case RADEON_INFO_DEVICE_ID:
 		value = dev->pci_device;


