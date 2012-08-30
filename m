Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2H3Bf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 21:35:58 -0400
Received: from mail.us.es ([193.147.175.20]:44001 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2H3BfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 21:35:03 -0400
Date: Thu, 30 Aug 2012 03:35:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] net/netfilter/nf_conntrack_netlink.c: fix error
 return code
Message-ID: <20120830013500.GD8878@1984>
References: <1346258957-7649-1-git-send-email-Julia.Lawall@lip6.fr>
 <1346258957-7649-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346258957-7649-7-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 06:49:16PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Initialize return variable before exiting on an error path.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>

Applied, thanks.
