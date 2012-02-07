Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2BGRL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:11:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34759 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2BGRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:11:28 -0500
Date: Tue, 07 Feb 2012 12:10:23 -0500 (EST)
Message-Id: <20120207.121023.2131074219122624371.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v8, kernel version 3.2.1] Source mode for macvlan
 interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <15266430.31328603700375.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <2400968.61328600903168.JavaMail.root@5-MeO-DMT.ynet.sk>
	<15266430.31328603700375.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 07 Feb 2012 09:10:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Tue, 7 Feb 2012 09:35:00 +0100 (CET)

> From: Stefan Gula <steweg@gmail.com>
> 
> New mode of macvlan interface called "source" allows one to set a list
> of allowed mac address, which is used to match against source mac
> address from received frames on underlying interface. This allows
> creating mac based VLAN associations, instead of standard port or tag
> based. The feature is useful to deploy 802.1x mac based behavior,
> where drivers of underlying interfaces doesn't allows that.
> Configuration is done through the netlink interface using e.g.:
>  ip link add link eth0 name macvlan0 type macvlan mode source
>  ip link add link eth0 name macvlan1 type macvlan mode source
>  ip link set link macvlan0 type macvlan macaddr add 00:11:11:11:11:11
>  ip link set link macvlan0 type macvlan macaddr add 00:22:22:22:22:22
>  ip link set link macvlan0 type macvlan macaddr add 00:33:33:33:33:33
>  ip link set link macvlan1 type macvlan macaddr add 00:33:33:33:33:33
>  ip link set link macvlan1 type macvlan macaddr add 00:44:44:44:44:44
> This allows clients with MAC addresses 00:11:11:11:11:11,
> 00:22:22:22:22:22 to be part of only VLAN associated with macvlan0
> interface. Clients with MAC addresses 00:44:44:44:44:44 with only VLAN
> associated with macvlan1 interface. And client with MAC address
> 00:33:33:33:33:33 to be associated with both VLANs.
> 
> Signed-off-by: Stefan Gula <steweg@gmail.com>
> 
> ---
> 
> V8 changes:
>    - added ability to list allowed mac address list back using devdump
>      ops method - required previous rtnetlink patch to be applied first

So you can't submit this until we've applied the final version of that
patch, because you have no idea what the exact mechanism is going to be to
enable dumping of your state, and therefore you can't code to the API
that enables your part of the dump.

The way that you rush your work is irritating, let things run their
course, in as much time as it takes.

And frankly there is no rush on this, as the next merge window for
new features is several months away.
