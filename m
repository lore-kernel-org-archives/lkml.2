Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031342Ab2HGWwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:52:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60358 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031068Ab2HGWrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        rucsoftsec@gmail.com, Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/49] caif: fix NULL pointer check
Date: Tue,  7 Aug 2012 15:44:51 -0700
Message-Id: <20120807222029.837393240@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alan Cox <alan@linux.intel.com>

[ Upstream commit c66b9b7d365444b433307ebb18734757cb668a02 ]

Reported-by: <rucsoftsec@gmail.com>
Resolves-bug: http://bugzilla.kernel.org/show_bug?44441
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/caif/caif_serial.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -325,6 +325,9 @@ static int ldisc_open(struct tty_struct
 
 	sprintf(name, "cf%s", tty->name);
 	dev = alloc_netdev(sizeof(*ser), name, caifdev_setup);
+	if (!dev)
+		return -ENOMEM;
+
 	ser = netdev_priv(dev);
 	ser->tty = tty_kref_get(tty);
 	ser->dev = dev;


