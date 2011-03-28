Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1C1RlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab1C1RlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:41:23 -0400
Date: Mon, 28 Mar 2011 18:41:19 +0100
From: Steven Hardy <shardy@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: mjg@redhat.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH 3/3] Resend : Fix memory leak in qcserial driver
Message-ID: <20110328174119.GC7030@shardy.csb>
References: <1301321186.4397.13.camel@shardy.csb>
 <20110328142148.GA19521@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328142148.GA19521@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 3 of 3, this simply adds a couple of missing free's in the error path:

Original description:
2 - Ensure that the serial->private data is freed in the event of the probe failing and returning -ENODEV.  This error-path leak is less likely but still possible, it was discussed previously but not actually fixed AFAICS: http://kerneltrap.org/mailarchive/linux-kernel/2010/6/14/4582980/thread, http://lkml.org/lkml/2010/6/20/234


Signed-off-by: Steve Hardy <shardy@redhat.com>


diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 0463dab..6219fce 100644
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
