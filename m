Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935409Ab1KJDcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:32:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934793Ab1KJDcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:20 2011
Message-Id: <20111109212720.010835005@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [193/262] net: Unlock sock before calling sk_free()
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b0691c8ee7c28a72748ff32e91b165ec12ae4de6 ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1257,6 +1257,7 @@ struct sock *sk_clone(const struct sock
 			/* It is still raw copy of parent, so invalidate
 			 * destructor and make plain sk_free() */
 			newsk->sk_destruct = NULL;
+			bh_unlock_sock(newsk);
 			sk_free(newsk);
 			newsk = NULL;
 			goto out;


