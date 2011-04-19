Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab1DSUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:19:51 -0400
Received: from kroah.org ([198.145.64.141]:35729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab1DSURn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:49 2011
Message-Id: <20110419201049.715422556@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Hardy <shardy@redhat.com>
Subject: [61/70] usb: qcserial add missing errorpath kfrees
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Hardy <shardy@redhat.com>

commit cb62d65f966146a39fdde548cb474dacf1d00fa5 upstream.

There are two -ENODEV error paths in qcprobe where the allocated private
data is not freed, this patch adds the two missing kfrees to avoid
leaking memory on the error path

Signed-off-by: Steven Hardy <shardy@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -167,6 +167,7 @@ static int qcprobe(struct usb_serial *se
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 		} else if (ifnum == 2) {
 			dbg("Modem port found");
@@ -191,6 +192,7 @@ static int qcprobe(struct usb_serial *se
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 		}
 		break;


