Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936490Ab2C3WH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:07:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965392Ab2C3VPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:15:51 -0400
Message-Id: <20120330194902.442439052@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Benjamin LaHaise <bcrl@kvack.org>,
        James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 135/149] Fix pppol2tp getsockname()
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Benjamin LaHaise <bcrl@kvack.org>

[ Upstream commit bbdb32cb5b73597386913d052165423b9d736145 ]

While testing L2TP functionality, I came across a bug in getsockname().  The
IP address returned within the pppol2tp_addr's addr memember was not being
set to the IP  address in use.  This bug is caused by using inet_sk() on the
wrong socket (the L2TP socket rather than the underlying UDP socket), and was
likely introduced during the addition of L2TPv3 support.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -915,7 +915,7 @@ static int pppol2tp_getname(struct socke
 		goto end_put_sess;
 	}
 
-	inet = inet_sk(sk);
+	inet = inet_sk(tunnel->sock);
 	if (tunnel->version == 2) {
 		struct sockaddr_pppol2tp sp;
 		len = sizeof(sp);


