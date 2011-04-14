Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1DNFyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 01:54:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:32994 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1DNFym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 01:54:42 -0400
Date: Thu, 14 Apr 2011 09:53:11 +0800
From: Simon Horman <horms@verge.net.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Eugene Teo <eugene@redhat.com>, Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Pekka Savola <pekkas@netcore.fi>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
Message-ID: <20110414015310.GC5167@verge.net.au>
References: <20110409101514.GA4262@albatros>
 <BANLkTi=ogJg_uJqsJFpnwnnr6LS+SFT3Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=ogJg_uJqsJFpnwnnr6LS+SFT3Vg@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 01:29:49PM +0300, Alexey Dobriyan wrote:
> On Sat, Apr 9, 2011 at 1:15 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:

[snip]

> > @@ -714,8 +790,22 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
> >                        &net->ipv4.sysctl_icmp_ratemask;
> >                table[6].data =
> >                        &net->ipv4.sysctl_rt_cache_rebuild_count;
> > +#ifdef CONFIG_IP_PING
> > +               table[7].data =
> > +                       &net->ipv4.sysctl_ping_group_range;
> > +#endif
> 
> Now I understand it's not related, but next sysctl will have
> "table[8].data = ..." line which is off-by-one if CONFIG_IP_PING=n.

Another good reason for the code to be non-optoinal
and not to have CONFIG_IP_PING.
