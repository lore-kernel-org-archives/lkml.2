Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965633Ab2E0BPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:15:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950Ab2E0BP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:15:29 -0400
Message-Id: <20120527002511.613091378@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:28 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [ 22/91] drivers/staging/comedi/comedi_fops.c: add missing vfree
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@lip6.fr>

commit abae41e6438b798e046d721b6ccdd55b4a398170 upstream.

aux_free is freed on all other exits from the function.  By removing the
return, we can benefit from the vfree already at the end of the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -280,7 +280,7 @@ static int do_devconfig_ioctl(struct com
 	if (ret == 0) {
 		if (!try_module_get(dev->driver->module)) {
 			comedi_device_detach(dev);
-			return -ENOSYS;
+			ret = -ENOSYS;
 		}
 	}
 


