Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2AWOLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:11:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62432 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2AWOLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:11:24 -0500
Message-ID: <1327327879.2525.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [patch v1, kernel version 3.2.1] Source mode for macvlan
 interaface
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Gula <steweg@ynet.sk>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2012 15:11:19 +0100
In-Reply-To: <22013455.801327321838477.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <22013455.801327321838477.JavaMail.root@5-MeO-DMT.ynet.sk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 23 janvier 2012 à 13:30 +0100, Stefan Gula a écrit :
> From: Stefan Gula <steweg@gmail.com>
> 
> New mode of macvlan interface called "source" allows one to specify,
> which  frames are allowed to be received by given macvlan interface.
> This logic is used only on received frames on underlaying interface.
> The ability to send frames from macvlan interface through underlaying
> interface is not modified. This feature allows one to simulate 802.1x
> mac based VLAN bahaviour by using proper netlink message to configure
> this behavior with utililty such as "ip link" from iproute2 suite.
> 
> Signed-off-by: Stefan Gula <steweg@gmail.com>

Please limit line lengths to 70 chars.

I dont understand your patch description at all, and reading its body I
still dont understand its purpose.

Is it sort of firewall rules (ebtable) or bridging code ?

> +static void macvlan_hash_del_sources(struct macvlan_source_list *list,
> +					bool sync)
> +{
> +	hlist_del_rcu(&list->hlist);
> +	kfree_rcu(list, rcu);
> +	if (sync)
> +		synchronize_rcu();
> +}
> +

Please explain why are you using synchronize_rcu() here, as there must
be a good reason, but I missed it.



