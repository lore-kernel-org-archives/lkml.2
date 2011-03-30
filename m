Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab1C3V2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:28:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:33747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637Ab1C3VJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238361"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jslaby@suse.cz, ak@linux.intel.com, alan@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [199/275] USB: serial/kobil_sct, fix potential tty NULL dereference
Message-Id: <20110330210723.3E4A93E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jiri Slaby <jslaby@suse.cz>

commit 6960f40a954619857e7095a6179eef896f297077 upstream.

Make sure that we check the return value of tty_port_tty_get.
Sometimes it may return NULL and we later dereference that.

The only place here is in kobil_read_int_callback, so fix it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/kobil_sct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/serial/kobil_sct.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/kobil_sct.c	2011-03-29 22:50:40.699217027 -0700
+++ linux-2.6.35.y/drivers/usb/serial/kobil_sct.c	2011-03-29 23:03:02.423238165 -0700
@@ -372,7 +372,7 @@
 	}
 
 	tty = tty_port_tty_get(&port->port);
-	if (urb->actual_length) {
+	if (tty && urb->actual_length) {
 
 		/* BEGIN DEBUG */
 		/*
