Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2IIX36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:29:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51278 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033Ab2IIXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:31 -0400
Message-Id: <20120909224159.216824033@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>
Subject: [ 62/95] drm/radeon: fix use after free in ATRM bios reading code.
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit de47a9cd62771e3e78954d855d2304fbad4c5a44 upstream.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=45503

Reported-and-Debugged-by: mlambda@gmail.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index 13ac63b..98724fc 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -59,8 +59,9 @@ static int radeon_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 
 	obj = (union acpi_object *)buffer.pointer;
 	memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
+	len = obj->buffer.length;
 	kfree(buffer.pointer);
-	return obj->buffer.length;
+	return len;
 }
 
 bool radeon_atrm_supported(struct pci_dev *pdev)


