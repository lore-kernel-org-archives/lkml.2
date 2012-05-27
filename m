Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab2E0Bov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:44:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964929Ab2E0BJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:09:26 -0400
Message-Id: <20120527010430.113217653@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:08 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>
Subject: [ 45/94] tty: Allow uart_register/unregister/register
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 1e66cded334e6cea596c72f6f650eec351b1e959 upstream.

This is legitimate but because we don't clear the drv->state pointer in the
unregister code causes a bogus BUG().

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=42880
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2283,6 +2283,7 @@ void uart_unregister_driver(struct uart_
 	tty_unregister_driver(p);
 	put_tty_driver(p);
 	kfree(drv->state);
+	drv->state = NULL;
 	drv->tty_driver = NULL;
 }
 


