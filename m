Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2E1DtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:49:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51981 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780Ab2E1D3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:22 -0400
Message-Id: <20120528031207.999046920@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 037/117] USB: cdc-wdm: sanitize error returns
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 24a85bae5da2b43fed423859c09c5a81ab359473 upstream.

wdm_flush() returns unsanitized USB error codes.
They must be cleaned up to before being anded to user space

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index c6f6560..b29a981 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -531,7 +531,7 @@ static int wdm_flush(struct file *file, fl_owner_t id)
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
 
-	return desc->werr;
+	return usb_translate_errors(desc->werr);
 }
 
 static unsigned int wdm_poll(struct file *file, struct poll_table_struct *wait)


