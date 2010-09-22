Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0IVRFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:05:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46956 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0IVRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ixYWZ9p9TQPnaDCYtl+ZNdAyHCpssesXDc0+kmkWjqvoum1R2xDkQQMMG7vdtxZi+z
         wwGDMXXrMfiNcAbC1UWWiniISL/UdUVFyKkjc0baOmIUOB4XP9GSlMz0IPymC81vXt9H
         KkMW/xA1l95hD8+sn4y+gKPpD2dc8L4FYG4ww=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 18:05:35 +0100
Message-ID: <AANLkTi=-aZt5TySqJSjFvu8+bZ002JvfVdY1N5L4opAC@mail.gmail.com>
Subject: [2.6.36-rc5] VGA arbiter fixlet...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct function being needlessly visible outside compilation unit
when the only users are internal.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index b87569e..f366f96 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -598,7 +598,7 @@ static inline void
vga_update_device_decodes(struct vga_device *vgadev,
     pr_debug("vgaarb: decoding count now is: %d\n", vga_decode_count);
 }

-void __vga_set_legacy_decoding(struct pci_dev *pdev, unsigned int
decodes, bool userspace)
+static void __vga_set_legacy_decoding(struct pci_dev *pdev, unsigned
int decodes, bool userspace)
 {
     struct vga_device *vgadev;
     unsigned long flags;
-- 
Daniel J Blueman
