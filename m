Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776Ab2D0UPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:15:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759649Ab2D0UO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:14:58 -0400
Date: Fri, 27 Apr 2012 16:14:59 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 1/2] netfilter: conntrack: remove RCU usage in
 conntrack notifier
Message-ID: <20120427201459.GA31254@d2.synalogic.ca>
References: <1335551333-6103-1-git-send-email-bpoirier@suse.de>
 <1335553131.2775.252.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335553131.2775.252.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/04/27 20:58, Eric Dumazet wrote:
> On Fri, 2012-04-27 at 14:28 -0400, Benjamin Poirier wrote:
> > I think that the rcu usage in this code is pointless. It should either be
> > removed or, if it was intended to protect against something, it ought to make
> > that clear.
> > 
> > 1) The code does not make use of the deferred deletion/wait for completion rcu
> > api (ie. synchronize_rcu(), call_rcu()).
> > 2) It does not benefit from the barriers implied by the rcu primitives used.
> > The code deals with callback pointers. There's no need to order writes to the
> > function code (!) before writes to the function pointers here.
> > ---
> 
> At a first glance, this seems pretty wrong.
> 
> code can disappear under you, thats for sure.
> 
> CONFIG_NF_CT_NETLINK=m
> 
> hint : module unload contains an rcu barrier.
> 

Thank you Eric. I had indeed failed to consider module load/unload
cases, which are effectively "writes to function code".
