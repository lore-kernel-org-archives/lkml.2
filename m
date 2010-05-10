Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab0EJWyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:54:00 -0400
Received: from kroah.org ([198.145.64.141]:33262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab0EJWwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:34 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:24 2010
Message-Id: <20100510223324.065549901@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [074/117] r8169: more broken register writes workaround
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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


