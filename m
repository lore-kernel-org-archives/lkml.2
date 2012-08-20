Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2HTEFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:05:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2HTEBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 32/46] staging: comedi: Fix reversed test in comedi_device_attach()
Date: Sun, 19 Aug 2012 20:59:08 -0700
Message-Id: <20120820035836.724999225@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 80eb7a506fdcea08f86c9dfc7c638303bf02a3c8 upstream.

Commit 3902a370281d2f2b130f141e8cf94eab40125769 (staging: comedi:
refactor comedi_device_attach() a bit) by yours truly introduced an
inverted logic bug in comedi_device_attach() for the case where the
driver expects the device to be configured by driver name rather than
board name.  The result of a strcmp() is being tested incorrectly.  Fix
it.

Thanks to Stephen N Chivers for discovering the bug and suggesting the
fix.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -144,7 +144,7 @@ int comedi_device_attach(struct comedi_d
 			dev->board_ptr = comedi_recognize(driv, it->board_name);
 			if (dev->board_ptr)
 				break;
-		} else if (strcmp(driv->driver_name, it->board_name))
+		} else if (strcmp(driv->driver_name, it->board_name) == 0)
 			break;
 		module_put(driv->module);
 	}


