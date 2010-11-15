Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0KOQ6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:58:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41693 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab0KOQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:58:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pBsDK06sZ38YXgb79xBJk7vZ/ubitfRzkuKdlplSrmKSz8j4a1beeHifcV/RVLd53g
         nrA0/1ZiN+wOiwSeZ74ons1y9EBh3GraWAAGhrUeW1ucJePlok3Yw5IGIk82molCriJn
         1iDreXi9+ppzMiwMiXGbVsmvzZh+m6o1lFWhc=
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101115.085254.104057401.davem@davemloft.net>
References: <20101115114651.8e6bad6c.sfr@canb.auug.org.au>
	 <20101115.085254.104057401.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 17:58:09 +0100
Message-ID: <1289840289.2607.92.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 novembre 2010 à 08:52 -0800, David Miller a écrit :
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 15 Nov 2010 11:46:51 +1100
> 
> > Caused by commit 1d7138de878d1d4210727c1200193e69596f93b3 ("igmp: RCU
> > conversion of in_dev->mc_list").  The for_each_pmc_rtnl and
> > for_each_pmc_rcu definitions are protected by  CONFIG_IP_MULTICAST, but
> > the uses are not ...
> 
> Thanks for the report, I've pushed the following fix:
> 
> --------------------
> ipv4: Fix build with multicast disabled.
> 
> net/ipv4/igmp.c: In function 'ip_mc_inc_group':
> net/ipv4/igmp.c:1228: error: implicit declaration of function 'for_each_pmc_rtnl'
> net/ipv4/igmp.c:1228: error: expected ';' before '{' token
> net/ipv4/igmp.c: In function 'ip_mc_unmap':
> net/ipv4/igmp.c:1333: error: expected ';' before 'igmp_group_dropped'
>  ...
> 
> Move for_each_pmc_rcu and for_each_pmc_rtnl macro definitions
> outside of multicast ifdef protection.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  

Oops thats right, sorry David, I missed this message.



