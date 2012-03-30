Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966277Ab2C3Vcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:32:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38311 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966149Ab2C3Vcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:36 -0400
X-Sasl-enc: 7atfmdKkpfI+Etl+mb2+s9nP9MQNd3Ep5rahAi2te6jS 1333143155
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:59 2012
Message-Id: <20120330194858.981028383@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Benjamin LaHaise <bcrl@kvack.org>,
        James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 163/175] Fix pppol2tp getsockname()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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


