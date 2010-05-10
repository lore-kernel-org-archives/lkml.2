Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab0EJXDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:03:45 -0400
Received: from kroah.org ([198.145.64.141]:45312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab0EJW6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:24 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:41 2010
Message-Id: <20100510223540.974834172@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [73/98] r8169: more broken register writes workaround
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

commit 908ba2bfd22253f26fa910cd855e4ccffb1467d0 upstream.

78f1cd02457252e1ffbc6caa44a17424a45286b8 ("fix broken register writes")
does not work for Al Viro's r8169 (XID 18000000).

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2832,8 +2832,13 @@ static void rtl_rar_set(struct rtl8169_p
 	spin_lock_irq(&tp->lock);
 
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
+
 	RTL_W32(MAC4, high);
+	RTL_R32(MAC4);
+
 	RTL_W32(MAC0, low);
+	RTL_R32(MAC0);
+
 	RTL_W8(Cfg9346, Cfg9346_Lock);
 
 	spin_unlock_irq(&tp->lock);


