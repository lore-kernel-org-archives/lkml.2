Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab1CEBTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:19:14 -0500
Received: from kroah.org ([198.145.64.141]:50113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760162Ab1CEA7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:59:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:35 2011
Message-Id: <20110305005635.276780989@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [07/73] Revert "Bluetooth: Enable USB autosuspend by default on btusb"
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 78794b2cdeac37ac1fd950fc9c4454b56d88ac03 upstream.

This reverts commit 556ea928f78a390fe16ae584e6433dff304d3014.

Jeff Chua reports that it can cause some bluetooth devices (he mentions
an Bluetooth Intermec scanner) to just stop responding after a while
with messages like

  [ 4533.361959] btusb 8-1:1.0: no reset_resume for driver btusb?
  [ 4533.361964] btusb 8-1:1.1: no reset_resume for driver btusb?

from the kernel. See also

  https://bugzilla.kernel.org/show_bug.cgi?id=26182

for other reports.

Reported-by: Jeff Chua <jeff.chua.linux@gmail.com>
Reported-by: Andrew Meakovski <meako@bigmir.net>
Reported-by: Jim Faulkner <jfaulkne@ccs.neu.edu>
Acked-by: Greg KH <gregkh@suse.de>
Acked-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1038,8 +1038,6 @@ static int btusb_probe(struct usb_interf
 
 	usb_set_intfdata(intf, data);
 
-	usb_enable_autosuspend(interface_to_usbdev(intf));
-
 	return 0;
 }
 


