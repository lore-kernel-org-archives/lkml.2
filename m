Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2JMKSG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 06:18:06 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:41447 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2JMKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 06:18:04 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnphAMQ+eVBV5h1yPGdsb2JhbABFhSmFI7UfGQEBAQEfGQ0ngk4vEwEPGIECChoKCYgIu1wUkgIDm12NLg
X-IronPort-AV: E=Sophos;i="4.80,581,1344204000"; 
   d="scan'208";a="428601574"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, Peter Stuge <peter@stuge.se>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, stable@kernel.org
Subject: [PATCH v3] usbdevfs: Fix broken scatter-gather transfer
Date: Sat, 13 Oct 2012 12:20:36 +0200
Message-Id: <1350123636-4801-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handling of large output bulk transfers is broken; the same user
page is read over and over again. Fixed with this patch.

Cc: stable@kernel.org
Acked-by: Peter Stuge <peter@stuge.se>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Greg,

Here is the formal and third version of the patch. Version two still
made me nervous, so I moved the increment to where it is clear that
the buffer pointer is never referenced again later in the function. I
still kept the ACKS, hope that is alright with everyone.

Thanks,
Henrik

 drivers/usb/core/devio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index ebb8a9d..7f75343 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1348,6 +1348,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 					ret = -EFAULT;
 					goto error;
 				}
+				uurb->buffer += u;
 			}
 			totlen -= u;
 		}
-- 
1.7.12.2

