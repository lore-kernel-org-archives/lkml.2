Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab1FILfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:35:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab1FILfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:35:10 -0400
Date: Thu, 9 Jun 2011 12:35:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: Micha? Miros?aw <mirqus@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 10/14] netvm: Set PF_MEMALLOC as appropriate during SKB
 processing
Message-ID: <20110609113505.GR5247@suse.de>
References: <1307606573-24704-1-git-send-email-mgorman@suse.de>
 <1307606573-24704-11-git-send-email-mgorman@suse.de>
 <BANLkTimUE9yb-DegdUk0BbbOGWoUhEBrqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimUE9yb-DegdUk0BbbOGWoUhEBrqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 12:21:31PM +0200, Micha? Miros?aw wrote:
> 2011/6/9 Mel Gorman <mgorman@suse.de>:
> [...]
> > +/*
> > + * Limit which protocols can use the PFMEMALLOC reserves to those that are
> > + * expected to be used for communication with swap.
> > + */
> > +static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
> > +{
> > +       switch (skb->protocol) {
> > +       case __constant_htons(ETH_P_ARP):
> > +       case __constant_htons(ETH_P_IP):
> > +       case __constant_htons(ETH_P_IPV6):
> > +       case __constant_htons(ETH_P_8021Q):
> > +               return true;
> > +       default:
> > +               return false;
> > +       }
> > +}
> 
> This is not needed and wrong. Whatever list there will be, it's going
> to always miss some obscure setup (or not that obscure, like
> ATAoverEthernet).
> 

NBD is updated in the series to set the socket information
appropriately but the same cannot be said of AoE. The necessary
changes have been made IPv4 and IPv6 to handle pfmemalloc sockets
but the same cannot be necessarily said for the other protocols. Yes,
the check could be removed but leaving it there makes a clear statement
on what scenario can be reasonably expected to work.

-- 
Mel Gorman
SUSE Labs
