Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1LGBy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:54:27 -0500
Received: from numidia.opendz.org ([98.142.220.152]:45729 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab1LGBy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:54:26 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Dec 2011 20:54:26 EST
Date: Wed, 7 Dec 2011 02:47:12 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Dmitry Kozlov <xeb@mail.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ppp: fix pptp double release_sock in pptp_bind()
Message-ID: <20111207014712.GB25869@dztty>
Mail-Followup-To: Dmitry Kozlov <xeb@mail.ru>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 drivers/net/ppp/pptp.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 89f829f..f8a6853 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -423,10 +423,8 @@ static int pptp_bind(struct socket *sock, struct sockaddr *uservaddr,
 	lock_sock(sk);
 
 	opt->src_addr = sp->sa_addr.pptp;
-	if (add_chan(po)) {
-		release_sock(sk);
+	if (add_chan(po))
 		error = -EBUSY;
-	}
 
 	release_sock(sk);
 	return error;
-- 
1.7.1
