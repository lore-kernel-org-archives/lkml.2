Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab2GRAL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:11:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48754 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab2GRADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:03:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Santosh Nayak <santoshprasadnayak@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 05/37] media: dvb-core: Release semaphore on error path dvb_register_device()
Date: Tue, 17 Jul 2012 17:02:42 -0700
Message-Id: <20120717232431.740700256@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Nayak <santoshprasadnayak@gmail.com>

commit 82163edcdfa4eb3d74516cc8e9f38dd3d039b67d upstream.

There is a missing "up_write()" here. Semaphore should be released
before returning error value.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/dvb-core/dvbdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -243,6 +243,7 @@ int dvb_register_device(struct dvb_adapt
 	if (minor == MAX_DVB_MINORS) {
 		kfree(dvbdevfops);
 		kfree(dvbdev);
+		up_write(&minor_rwsem);
 		mutex_unlock(&dvbdev_register_lock);
 		return -EINVAL;
 	}


