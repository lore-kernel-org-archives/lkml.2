Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab0KLVoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:44:24 -0500
Received: from kroah.org ([198.145.64.141]:41591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028Ab0KLVlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andres Salomon <dilinger@queued.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/19] tty: fix warning in synclink driver
Date: Fri, 12 Nov 2010 13:40:50 -0800
Message-Id: <1289598066-10112-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>

During builds I see the following warning -

  CC [M]  drivers/char/pcmcia/synclink_cs.o
drivers/char/pcmcia/synclink_cs.c:2194: warning: ‘mgslpc_get_icount’ defined but not used

The function is a callback meant to be assigned to get_icount (added during 0587102cf).
Fix accordingly.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/pcmcia/synclink_cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index bfc10f8..eaa4199 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2796,6 +2796,7 @@ static const struct tty_operations mgslpc_ops = {
 	.hangup = mgslpc_hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.get_icount = mgslpc_get_icount,
 	.proc_fops = &mgslpc_proc_fops,
 };
 
-- 
1.7.1

