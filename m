Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab2E0Bbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:31:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2E0BQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:16:13 -0400
Message-Id: <20120527002513.630212029@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:37 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [ 31/91] USB: cdc-wdm: sanitize error returns
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 24a85bae5da2b43fed423859c09c5a81ab359473 upstream.

wdm_flush() returns unsanitized USB error codes.
They must be cleaned up to before being anded to user space

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -534,7 +534,7 @@ static int wdm_flush(struct file *file,
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
 
-	return desc->werr;
+	return usb_translate_errors(desc->werr);
 }
 
 static unsigned int wdm_poll(struct file *file, struct poll_table_struct *wait)


