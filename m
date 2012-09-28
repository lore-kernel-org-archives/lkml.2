Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033026Ab2I1VNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:13:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53805 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759490Ab2I1Uke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:34 -0400
X-Sasl-enc: vYawLTmcB+X1P2tnDsbpPo25qbHS36CM2MHdCAN32mwt 1348864828
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 010/127] atm: fix info leak via getsockname()
Date: Fri, 28 Sep 2012 13:33:03 -0700
Message-Id: <20120928203047.018313757@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 3c0c5cfdcd4d69ffc4b9c0907cec99039f30a50a ]

The ATM code fails to initialize the two padding bytes of struct
sockaddr_atmpvc inserted for alignment. Add an explicit memset(0)
before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/atm/pvc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/atm/pvc.c
+++ b/net/atm/pvc.c
@@ -94,6 +94,7 @@ static int pvc_getname(struct socket *so
 		return -ENOTCONN;
 	*sockaddr_len = sizeof(struct sockaddr_atmpvc);
 	addr = (struct sockaddr_atmpvc *)sockaddr;
+	memset(addr, 0, sizeof(*addr));
 	addr->sap_family = AF_ATMPVC;
 	addr->sap_addr.itf = vcc->dev->number;
 	addr->sap_addr.vpi = vcc->vpi;


