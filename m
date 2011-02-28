Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1B1JeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:34:13 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:36584 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1B1JeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:34:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>,
        stable@kernel.org
Subject: [PATCH 2/2] USB: serial/kobil_sct, fix potential tty NULL dereference
Date: Mon, 28 Feb 2011 10:34:06 +0100
Message-Id: <1298885646-9293-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298885646-9293-1-git-send-email-jslaby@suse.cz>
References: <1298885646-9293-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we check the return value of tty_port_tty_get.
Sometimes it may return NULL and we later dereference that.

The only place here is in kobil_read_int_callback, so fix it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: stable@kernel.org
---
 drivers/usb/serial/kobil_sct.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index bd5bd85..b382d9a 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -372,7 +372,7 @@ static void kobil_read_int_callback(struct urb *urb)
 	}
 
 	tty = tty_port_tty_get(&port->port);
-	if (urb->actual_length) {
+	if (tty && urb->actual_length) {
 
 		/* BEGIN DEBUG */
 		/*
-- 
1.7.4.1


