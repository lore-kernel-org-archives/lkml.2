Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab1C3VSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:18:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:41846 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965210Ab1C3VJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279027"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jhovold@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [237/275] USB: cdc-acm: fix potential null-pointer dereference
Message-Id: <20110330210803.3CE3C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Johan Hovold <jhovold@gmail.com>

commit 15e5bee33ffc11d0e5c6f819a65e7881c5c407be upstream.

Must check return value of tty_port_tty_get.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/usb/class/cdc-acm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/class/cdc-acm.c	2011-03-29 23:03:03.135219948 -0700
+++ linux-2.6.35.y/drivers/usb/class/cdc-acm.c	2011-03-29 23:53:54.272148988 -0700
@@ -533,6 +533,8 @@
 	if (!ACM_READY(acm))
 		return;
 	tty = tty_port_tty_get(&acm->port);
+	if (!tty)
+		return;
 	tty_wakeup(tty);
 	tty_kref_put(tty);
 }
