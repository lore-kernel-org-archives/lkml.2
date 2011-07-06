Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1GFLH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:07:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49781 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1GFLH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:07:26 -0400
Date: Wed, 6 Jul 2011 08:07:30 -0300
From: Gustavo Padovan <padovan@profusion.mobi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
Message-ID: <20110706110730.GA5895@joana>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110706125329.6e5bdd1a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706125329.6e5bdd1a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [2011-07-06 12:53:29 +1000]:

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> net/bluetooth/l2cap_core.c between commit 9fa7e4f76f36 ("Bluetooth: Fix
> regression with incoming L2CAP connections") from the wireless-current
> tree and commit 89bc500e41fc ("Bluetooth: Add state tracking to struct
> l2cap_chan") from the net tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc net/bluetooth/l2cap_core.c
> index ebff14c,9ec9c8c..0000000
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@@ -2323,8 -2530,7 +2530,8 @@@ static inline int l2cap_config_req(stru
>   
>   	sk = chan->sk;
>   
> - 	if ((bt_sk(sk)->defer_setup && sk->sk_state != BT_CONNECT2) ||
> - 		 (!bt_sk(sk)->defer_setup && sk->sk_state != BT_CONFIG)) {
>  -	if (chan->state != BT_CONFIG) {
> ++	if ((bt_sk(sk)->defer_setup && chan->state != BT_CONNECT2) ||
> ++		 (!bt_sk(sk)->defer_setup && chan->state != BT_CONFIG)) {

Seems I need to merge my own trees. I'll do that. Thanks, Stephen.
And the fix is right ;)

	Gustavo
