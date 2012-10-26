Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2JZAN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:13:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:54067 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab2JZAIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 69/85] ipv4: Dont create nh exeption when the device mtu is smaller than the reported pmtu
Date: Thu, 25 Oct 2012 17:06:27 -0700
Message-Id: <20121026000038.054146021@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 7f92d334ba19a0d8e96f8f8f092219553367d921 ]

When a local tool like tracepath tries to send packets bigger than
the device mtu, we create a nh exeption and set the pmtu to device
mtu. The device mtu does not expire, so check if the device mtu is
smaller than the reported pmtu and don't crerate a nh exeption in
that case.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -909,6 +909,9 @@ static void __ip_rt_update_pmtu(struct r
 	struct dst_entry *dst = &rt->dst;
 	struct fib_result res;
 
+	if (dst->dev->mtu < mtu)
+		return;
+
 	if (mtu < ip_rt_min_pmtu)
 		mtu = ip_rt_min_pmtu;
 


