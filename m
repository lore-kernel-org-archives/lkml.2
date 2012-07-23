Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2GWBnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54460 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab2GWBnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:43 -0400
Message-Id: <20120723010656.515264174@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Santosh Nayak <santoshprasadnayak@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 033/108] [media] dvb-core: Release semaphore on error path
 dvb_register_device()
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Nayak <santoshprasadnayak@gmail.com>

commit 82163edcdfa4eb3d74516cc8e9f38dd3d039b67d upstream.

There is a missing "up_write()" here. Semaphore should be released
before returning error value.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/dvb-core/dvbdev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 00a6732..39eab73 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -243,6 +243,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if (minor == MAX_DVB_MINORS) {
 		kfree(dvbdevfops);
 		kfree(dvbdev);
+		up_write(&minor_rwsem);
 		mutex_unlock(&dvbdev_register_lock);
 		return -EINVAL;
 	}


