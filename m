Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1DDRCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:02:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1DDRCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:02:31 -0400
Subject: [PATCH 3/3] usb: qcserial add missing errorpath kfrees
From: Steven Hardy <shardy@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Aristeu Rozanski <aris@redhat.com>,
        mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1301936257.4891.20.camel@shardy.csb>
References: <1301321186.4397.13.camel@shardy.csb>
	 <20110328142148.GA19521@suse.de> <20110328221636.GA8195@shardy.csb>
	 <4D91C1EB.5060604@ru.mvista.com>  <1301936257.4891.20.camel@shardy.csb>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 18:02:25 +0100
Message-ID: <1301936545.4891.26.camel@shardy.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two -ENODEV error paths in qcprobe where the allocated private
data is not freed, this patch adds the two missing kfrees to avoid
leaking memory on the error path

Signed-off-by: Steven Hardy <shardy@redhat.com>
---
Repost of qcserial patches posted last week, hopefully addresses review 
comments and email-patch-format issues

 drivers/usb/serial/qcserial.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index cd63864..54a9dab 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -167,6 +167,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 		} else if (ifnum == 2) {
 			dbg("Modem port found");
@@ -191,6 +192,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
 					"Could not set interface, error %d\n",
 					retval);
 				retval = -ENODEV;
+				kfree(data);
 			}
 		}
 		break;
-- 
1.7.1



