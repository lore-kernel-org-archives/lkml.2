Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab1CZASI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:18:08 -0400
Received: from kroah.org ([198.145.64.141]:41786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab1CYXwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:42 2011
Message-Id: <20110325234842.645630790@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [35/55] USB: Do not pass negative length to snoop_urb()
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Sojka <sojkam1@fel.cvut.cz>

commit 9d02b42614149ebccf12c9c580601ed01bd83070 upstream.

When `echo Y > /sys/module/usbcore/parameters/usbfs_snoop` and
usb_control_msg() returns error, a lot of kernel memory is dumped to dmesg
until unhandled kernel paging request occurs.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -802,7 +802,7 @@ static int proc_control(struct dev_state
 				    tbuf, ctrl.wLength, tmo);
 		usb_lock_device(dev);
 		snoop_urb(dev, NULL, pipe, max(i, 0), min(i, 0), COMPLETE,
-			tbuf, i);
+			  tbuf, max(i, 0));
 		if ((i > 0) && ctrl.wLength) {
 			if (copy_to_user(ctrl.data, tbuf, i)) {
 				free_page((unsigned long)tbuf);


