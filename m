Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1HMOMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:12:55 -0400
Received: from www17.your-server.de ([213.133.104.17]:56358 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1HMOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:11:53 -0400
Subject: [PATCH] sctp: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:41:42 +0200
Message-ID: <1313228502.16820.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
--- a/include/net/sctp/sctp.h 2011-07-26 00:46:11.646827854 +0200
+++ b/include/net/sctp/sctp.h 2011-08-01 19:40:06.389592439 +0200
@@ -559,7 +559,7 @@ for (pos = chunk->subh.fwdtsn_hdr->skip;
 #define WORD_ROUND(s) (((s)+3)&~3)
 
 /* Make a new instance of type.  */
-#define t_new(type, flags)	(type *)kzalloc(sizeof(type), flags)
+#define t_new(type, flags)	kzalloc(sizeof(type), flags)
 
 /* Compare two timevals.  */
 #define tv_lt(s, t) \


