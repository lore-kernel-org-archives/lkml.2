Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2ACWsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:48:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab2ACWls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:26 2012
Message-Id: <20120103223326.183686887@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Djalal Harouni <tixxdz@opendz.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [61/75] ppp: fix pptp double release_sock in pptp_bind()
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Djalal Harouni <tixxdz@opendz.org>

[ Upstream commit a454daceb78844a09c08b6e2d8badcb76a5d73b9 ]

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/pptp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/pptp.c
+++ b/drivers/net/pptp.c
@@ -423,10 +423,8 @@ static int pptp_bind(struct socket *sock
 	lock_sock(sk);
 
 	opt->src_addr = sp->sa_addr.pptp;
-	if (add_chan(po)) {
-		release_sock(sk);
+	if (add_chan(po))
 		error = -EBUSY;
-	}
 
 	release_sock(sk);
 	return error;


