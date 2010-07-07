Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0GGJTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 05:19:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41997 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0GGJTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 05:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VgEoldp/QYqSg9XhGfA4Ed3cRYa7jqsFlX8RByp3b27dZ4m0+tqf5gIy9dp5TP/tFj
         xw+ijyf92kwmLS8rNTrmusPvsHdsKfgYzK1JLwpY8yxlKJ7T2cPOwpE7W0Q35BrDRQjI
         7YRsrvfSJNbtF8yXlReHqkNkInjUi/550aJNk=
MIME-Version: 1.0
Date: Wed, 7 Jul 2010 17:19:06 +0800
Message-ID: <AANLkTinEKn_UBpjf3k2DZn1euMM6z2UM_yeDPvdEQkav@mail.gmail.com>
Subject: wensong@linux-vs.org, horms@verge.net.au
From: xiaoyu Du <tingsrain@gmail.com>
To: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi，all

After I compared the sctp with tcp and udp, I thinkt his a bug that
sctp_dnat_handler Incorrectly invoked ip_vs_app_pkt_out.
below is the patch.

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
-               if (!ip_vs_app_pkt_out(cp, skb))
+               if (!ip_vs_app_pkt_in(cp, skb))
                       return 0;
       }

--
