Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0IHFTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:19:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38471 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0IHFTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EzorgFOB4ssfx27bBW/kODQLIcw5Xh5rHpVDULpSkFY6lvgk6zWajYxR9ceETpltAf
         F2dLt7etFVmtEtwzld/3m9hmGUzcAbWj/6wbYVnEwLMpWmmQzXJATkLXVaNyR87/Xi2s
         NnsRvaPdDE4lBVslELnFR9/Tk6yTksAbTvw9E=
Subject: Re: [PATCH] netlink: Fix kfree NULL pointer
From: Eric Dumazet <eric.dumazet@gmail.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
References: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 07:19:45 +0200
Message-ID: <1283923185.2634.772.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 septembre 2010 à 13:13 +0800, jovi zhang a écrit :
> It will kfree NULL pointer if listeners is NULL. fix it.
> 
> Signed-off-by: bookjovi@gmail.com
> net/netlink/af_netlink.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 980fe4a..1c7bf48 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1532,8 +1532,10 @@ netlink_kernel_create(struct net *net, int
> unit, unsigned int groups,
>        if (input)
>                nlk_sk(sk)->netlink_rcv = input;
> 
> -       if (netlink_insert(sk, net, 0))
> +       if (netlink_insert(sk, net, 0)) {
> +               kfree(listeners);
>                goto out_sock_release;
> +       }
> 
>        nlk = nlk_sk(sk);
>        nlk->flags |= NETLINK_KERNEL_SOCKET;
> @@ -1553,7 +1555,6 @@ netlink_kernel_create(struct net *net, int unit,
> unsigned int groups,
>        return sk;
> 
> out_sock_release:
> -       kfree(listeners);
>        netlink_kernel_release(sk);
>        return NULL;


This patch is not needed

kfree(NULL) is legal



