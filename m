Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308Ab2E0BLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:11:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660Ab2E0BLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:11:08 -0400
Message-Id: <20120527010432.927126508@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:28 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Guillaume=20Cl=C3=A9ment?= <guillaume@baobob.org>,
        Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 65/94] gma500: Fix Poulsbo suspend/resume crash on devices with SDVO ports
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 7beff62ee39d3ccf088bb77f61a63037f714d235 upstream.

Reported-by: Guillaume Clément <guillaume@baobob.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/psb_device.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gma500/psb_device.c
+++ b/drivers/gpu/drm/gma500/psb_device.c
@@ -196,7 +196,8 @@ static int psb_save_display_registers(st
 	}
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
-		connector->funcs->save(connector);
+		if (connector->funcs->save)
+			connector->funcs->save(connector);
 
 	mutex_unlock(&dev->mode_config.mutex);
 	return 0;
@@ -233,7 +234,8 @@ static int psb_restore_display_registers
 			crtc->funcs->restore(crtc);
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
-		connector->funcs->restore(connector);
+		if (connector->funcs->restore)
+			connector->funcs->restore(connector);
 
 	mutex_unlock(&dev->mode_config.mutex);
 	return 0;


