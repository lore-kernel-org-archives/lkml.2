Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406Ab1CEBN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:13:57 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:55168 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760398Ab1CEBN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:13:56 -0500
X-Greylist: delayed 4719 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 20:13:55 EST
X-ClientAddr: 85.127.41.184
Date: Sat, 5 Mar 2011 00:49:41 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/macvtap: fix error check
Message-ID: <20110305004941.7b195e9d@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: p24Na5na018764
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'len' is unsigned of type size_t and can't be negative.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/net/macvtap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 5933621..fc27a99 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -528,8 +528,9 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q,
 		vnet_hdr_len = q->vnet_hdr_sz;
 
 		err = -EINVAL;
-		if ((len -= vnet_hdr_len) < 0)
+		if (len < vnet_hdr_len)
 			goto err;
+		len -= vnet_hdr_len;
 
 		err = memcpy_fromiovecend((void *)&vnet_hdr, iv, 0,
 					   sizeof(vnet_hdr));
-- 
1.7.3.4
