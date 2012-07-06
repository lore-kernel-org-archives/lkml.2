Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2GFTql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 15:46:41 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:34989 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2GFTqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:46:39 -0400
Date: Fri, 6 Jul 2012 19:47:41 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Dilip Daya <dilip.daya@hp.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: Network namespace and bonding WARNING at fs/proc/generic.c
 remove_proc_entry
Message-ID: <20120706194741.GA22113@mail.hallyn.com>
References: <1340900320.3441.88.camel@pro6455b.example.com>
 <20120705220749.GA11255@mail.hallyn.com>
 <87ehopu3e5.fsf@xmission.com>
 <20120706170538.GA31679@mail.hallyn.com>
 <87fw94g1kq.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw94g1kq.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> >> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >> index 2ee8cf9..818ed64 100644
> >> --- a/drivers/net/bonding/bond_main.c
> >> +++ b/drivers/net/bonding/bond_main.c
> >> @@ -4345,6 +4345,9 @@ static void bond_setup(struct net_device *bond_dev)
> >>         bond_dev->priv_flags |= IFF_BONDING;
> >>         bond_dev->priv_flags &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
> >>  
> >> +       /* Don't allow bond devices to change network namespaces. */
> >> +       bond_dev->features |= NETIF_F_LOCAL;
> >
> > I believe this needs to be NETIF_F_NETNS_LOCAL.  Test build still going with
> > that change.
> 
> Yes that is what I mean.

With that change, build is fine, boots fine, I can't pass a bond to another
netns (preventing the problem), and I can create a bond in a child netns
just fine.

Thanks!

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

-serge
