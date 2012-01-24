Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab2AXCsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:48:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762Ab2AXCsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:33 2012
Message-Id: <20120124023933.632181885@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miroslav Slugen <thunder.mmm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [109/129] [media] cx23885-dvb: check if dvb_attach() succeded
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 890
Lines: 30

From: Miroslav Slugen <thunder.mmm@gmail.com>

commit a7c8aadad39428b64d26c3971d967f8314e2397d upstream.

Fix possible null dereference for Leadtek DTV 3200H
XC4000 tuner when no firmware file available.

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-dvb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -940,6 +940,11 @@ static int dvb_register(struct cx23885_t
 
 			fe = dvb_attach(xc4000_attach, fe0->dvb.frontend,
 					&dev->i2c_bus[1].i2c_adap, &cfg);
+			if (!fe) {
+				printk(KERN_ERR "%s/2: xc4000 attach failed\n",
+				       dev->name);
+				goto frontend_detach;
+			}
 		}
 		break;
 	case CX23885_BOARD_TBS_6920:


