Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0LHCFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:05:39 -0500
Received: from kroah.org ([198.145.64.141]:58454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab0LHArg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:36 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:31 2010
Message-Id: <20101208004431.578806315@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Bock <bock@tfh-berlin.de>
Subject: [073/127] USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit c990600d340641150f7270470a64bd99a5c0b225 upstream.

They should not be writable by any user.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Bock <bock@tfh-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/cypress_cy7c63.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -195,11 +195,9 @@ static ssize_t get_port1_handler(struct
 	return read_port(dev, attr, buf, 1, CYPRESS_READ_PORT_ID1);
 }
 
-static DEVICE_ATTR(port0, S_IWUGO | S_IRUGO,
-		   get_port0_handler, set_port0_handler);
+static DEVICE_ATTR(port0, S_IRUGO | S_IWUSR, get_port0_handler, set_port0_handler);
 
-static DEVICE_ATTR(port1, S_IWUGO | S_IRUGO,
-		   get_port1_handler, set_port1_handler);
+static DEVICE_ATTR(port1, S_IRUGO | S_IWUSR, get_port1_handler, set_port1_handler);
 
 
 static int cypress_probe(struct usb_interface *interface,


