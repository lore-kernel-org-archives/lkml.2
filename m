Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab2JAXD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:59 -0400
Received: from 1wt.eu ([62.212.114.60]:35692 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757818Ab2JAXDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:55 -0400
Message-Id: <20121001225200.152686997@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 060/180] USB: ftdi_sio: fix problem when the manufacture is a NULL string
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 656d2b3964a9d0f9864d472f8dfa2dd7dd42e6c0 upstream.

On some misconfigured ftdi_sio devices, if the manufacturer string is
NULL, the kernel will oops when the device is plugged in.  This patch
fixes the problem.

Reported-by: Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>
Tested-by: Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/ftdi_sio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0a1ccaa..c374beb 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1784,7 +1784,8 @@ static int ftdi_8u2232c_probe(struct usb_serial *serial)
 
 	dbg("%s", __func__);
 
-	if (strcmp(udev->manufacturer, "CALAO Systems") == 0)
+	if ((udev->manufacturer) &&
+	    (strcmp(udev->manufacturer, "CALAO Systems") == 0))
 		return ftdi_jtag_probe(serial);
 
 	return 0;
-- 
1.7.2.1.45.g54fbc



