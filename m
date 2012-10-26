Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2JZA2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:28:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:53423 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab2JZAHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Stuge <peter@stuge.se>, Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [ 04/85] usbdevfs: Fix broken scatter-gather transfer
Date: Thu, 25 Oct 2012 17:05:22 -0700
Message-Id: <20121026000031.575096656@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 014639003c77a51fc319c9fdf225e7747cb6e18d upstream.

The handling of large output bulk transfers is broken; the same user
page is read over and over again. Fixed with this patch.

Acked-by: Peter Stuge <peter@stuge.se>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1348,6 +1348,7 @@ static int proc_do_submiturb(struct dev_
 					ret = -EFAULT;
 					goto error;
 				}
+				uurb->buffer += u;
 			}
 			totlen -= u;
 		}


