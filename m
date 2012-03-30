Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935950Ab2C3VRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:17:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935911Ab2C3VRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:17:00 -0400
Message-Id: <20120330194826.918615373@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>
Subject: [ 008/175] USB: ftdi_sio: fix problem when the manufacture is a NULL string
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 656d2b3964a9d0f9864d472f8dfa2dd7dd42e6c0 upstream.

On some misconfigured ftdi_sio devices, if the manufacturer string is
NULL, the kernel will oops when the device is plugged in.  This patch
fixes the problem.

Reported-by: Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>
Tested-by: Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1763,7 +1763,8 @@ static int ftdi_8u2232c_probe(struct usb
 
 	dbg("%s", __func__);
 
-	if (strcmp(udev->manufacturer, "CALAO Systems") == 0)
+	if ((udev->manufacturer) &&
+	    (strcmp(udev->manufacturer, "CALAO Systems") == 0))
 		return ftdi_jtag_probe(serial);
 
 	return 0;


