Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1DKS44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:56:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40856 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1DKS4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:56:54 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
cc: andy@greyhouse.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding:set save_load to 0 when initializing
In-reply-to: <1302270019-11698-1-git-send-email-panweiping3@gmail.com>
References: <1302270019-11698-1-git-send-email-panweiping3@gmail.com>
Comments: In-reply-to =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= <panweiping3@gmail.com>
   message dated "Fri, 08 Apr 2011 21:40:19 +0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 11:56:47 -0700
Message-ID: <30474.1302548207@death>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>It is unnecessary to set save_load to 1 here,
>as the tx_hashtbl is just kzalloced.
>
>Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>

	I don't think this will cause any behavioral change, but I'll
grant is more correct in intent (there's no load information to save at
this point).

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

>---
> drivers/net/bonding/bond_alb.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index 9bc5de3..ab69e5a 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -176,7 +176,7 @@ static int tlb_initialize(struct bonding *bond)
> 	bond_info->tx_hashtbl = new_hashtbl;
>
> 	for (i = 0; i < TLB_HASH_TABLE_SIZE; i++) {
>-		tlb_init_table_entry(&bond_info->tx_hashtbl[i], 1);
>+		tlb_init_table_entry(&bond_info->tx_hashtbl[i], 0);
> 	}
>
> 	_unlock_tx_hashtbl(bond);
>-- 
>1.7.4
>
