Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031136Ab2CITtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:49:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031079Ab2CITti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:38 -0500
Message-Id: <20120309190208.204133426@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 73/95] media: staging: lirc_serial: Fix deadlock on resume failure
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 1ff1d88e862948ae5bfe490248c023ff8ac2855d upstream.

A resume function cannot remove the device it is resuming!

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/staging/media/lirc/lirc_serial.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1127,10 +1127,8 @@ static int lirc_serial_resume(struct pla
 {
 	unsigned long flags;
 
-	if (hardware_init_port() < 0) {
-		lirc_serial_exit();
+	if (hardware_init_port() < 0)
 		return -EINVAL;
-	}
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	/* Enable Interrupt */


