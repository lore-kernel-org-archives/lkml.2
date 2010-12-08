Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0LHBVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:21:08 -0500
Received: from kroah.org ([198.145.64.141]:33598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533Ab0LHBDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:04 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:42 2010
Message-Id: <20101208005742.376880471@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kevin Lloyd <klloyd@sierrawireless.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [209/289] USB: storage: sierra_ms: fix sysfs file attribute
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit d9624e75f6ad94d8a0718c1fafa89186d271a78c upstream.

A non-writable sysfs file shouldn't have writable attributes.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/sierra_ms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/sierra_ms.c
+++ b/drivers/usb/storage/sierra_ms.c
@@ -121,7 +121,7 @@ static ssize_t show_truinst(struct devic
 	}
 	return result;
 }
-static DEVICE_ATTR(truinst, S_IWUGO | S_IRUGO, show_truinst, NULL);
+static DEVICE_ATTR(truinst, S_IRUGO, show_truinst, NULL);
 
 int sierra_ms_init(struct us_data *us)
 {


