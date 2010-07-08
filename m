Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab0GHBzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:55:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56900 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab0GHBzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=F+D0ksATz8RjeifbDAiu/GPYOKszdHe9/2JfjF8760+Q+3apvxa2kDMSYN4vziCDC6
         myDo8bK7Dt/dybYWRV8M+K27Y9GciF8tqxmIlCy5AjXrWeNU/FNiD4Desgzpk4l2on1k
         DtBjFXepFO4NOw8kNIfOdgmQaMIzH6kwgmb8g=
MIME-Version: 1.0
Date: Thu, 8 Jul 2010 09:55:04 +0800
Message-ID: <AANLkTikS9SSVT5soWZYmzxeJkR5vO__cuedk7ZgmTx5y@mail.gmail.com>
Subject: [PATCH] lvs sctp protocol handler is incorrectly invoked 
	ip_vs_app_pkt_out
From: xiaoyu Du <tingsrain@gmail.com>
To: linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org
Cc: wensong@linux-vs.org, horms@verge.net.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lvs sctp protocol handler is incorrectly invoked ip_vs_app_pkt_out
Since there's no sctp helpers at present, it does the same thing as
ip_vs_app_pkt_in.

Signed-off-by: Xiaoyu Du <tingsrain@gmail.com>

---
 net/netfilter/ipvs/ip_vs_proto_sctp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c
b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index c9a3f7a..db55759 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -173,7 +173,7 @@ sctp_dnat_handler(struct sk_buff *skb,
 			return 0;

 		/* Call application helper if needed */
-		if (!ip_vs_app_pkt_out(cp, skb))
+		if (!ip_vs_app_pkt_in(cp, skb))
 			return 0;
 	}

--
