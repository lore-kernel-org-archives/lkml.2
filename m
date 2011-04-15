Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1DOKoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:44:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab1DOKoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:44:06 -0400
Date: Fri, 15 Apr 2011 11:44:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH 08/12] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
Message-ID: <20110415104401.GC22688@suse.de>
References: <1302777698-28237-1-git-send-email-mgorman@suse.de>
 <1302777698-28237-9-git-send-email-mgorman@suse.de>
 <20110414.143335.104052252.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110414.143335.104052252.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 02:33:35PM -0700, David Miller wrote:
> From: Mel Gorman <mgorman@suse.de>
> Date: Thu, 14 Apr 2011 11:41:34 +0100
> 
> > +extern int memalloc_socks;
> > +static inline int sk_memalloc_socks(void)
> > +{
> > +	return memalloc_socks;
> > +}
> > +
>  ...
> > +static DEFINE_MUTEX(memalloc_socks_lock);
> > +int memalloc_socks __read_mostly;
> 
> Please use an atomic_t, it has to be more efficient than this mutex
> business.

Will fix.

Thanks.

-- 
Mel Gorman
SUSE Labs
