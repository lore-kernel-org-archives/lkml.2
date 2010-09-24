Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab0IXQ2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:12 -0400
Received: from kroah.org ([198.145.64.141]:46091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572Ab0IXQ2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.482052666@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [18/80] drivers/net/usb/hso.c: prevent reading uninitialized memory
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 7011e660938fc44ed86319c18a5954e95a82ab3e upstream.

Fixed formatting (tabs and line breaks).

The TIOCGICOUNT device ioctl allows unprivileged users to read
uninitialized stack memory, because the "reserved" member of the
serial_icounter_struct struct declared on the stack in hso_get_count()
is not altered or zeroed before being copied back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/hso.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1653,6 +1653,8 @@ static int hso_get_count(struct hso_seri
 	struct uart_icount cnow;
 	struct hso_tiocmget  *tiocmget = serial->tiocmget;
 
+	memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 	if (!tiocmget)
 		 return -ENOENT;
 	spin_lock_irq(&serial->serial_lock);


