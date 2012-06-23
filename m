Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2FWAlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 20:41:08 -0400
Received: from mail.us.es ([193.147.175.20]:51757 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab2FWAlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 20:41:06 -0400
Date: Sat, 23 Jun 2012 02:41:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [net-next:master 49/50]
 net/netfilter/nfnetlink_queue_ct.c:23:18: sparse: incompatible types in
 comparison expression (different address spaces)
Message-ID: <20120623004103.GA21550@1984>
References: <20120619060050.GA14867@localhost>
 <20120619112823.GB445@1984>
 <20120619114113.GA19526@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619114113.GA19526@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 02:00:50PM +0800, wfg@linux.intel.com wrote:
> Hi Pablo,
> 
> There are new sparse warnings show up in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> head:   6bdc5f49e365a5403b9fdef01ceb37241ab00f9b
> commit: 7c62234547255ce4c385a218915965bc2f14fe45 [49/50] netfilter: nfnetlink_queue: fix compilation with NF_CONNTRACK disabled
> 
> All sparse warnings:
> 
> net/netfilter/nfnetlink_queue_ct.c:23:18: sparse: incompatible types in comparison expression (different address spaces)
> net/netfilter/nfnetlink_queue_ct.c:45:18: sparse: incompatible types in comparison expression (different address spaces)
> net/netfilter/nfnetlink_queue_ct.c:63:18: sparse: incompatible types in comparison expression (different address spaces)
> net/netfilter/nfnetlink_queue_ct.c:91:18: sparse: incompatible types in comparison expression (different address spaces)
> net/netfilter/nf_conntrack_netlink.c:1100:27: sparse: incompatible types in comparison expression (different address spaces)
> net/netfilter/nf_conntrack_netlink.c:1222:34: sparse: incompatible types in comparison expression (different address spaces)
> net/netfilter/nf_conntrack_netlink.c:1222:34: sparse: incompatible types in comparison expression (different address spaces)
> 
> net/netfilter/nfnetlink_queue_ct.c:23:
>     20		struct nf_conn *ct;
>     21	
>     22		/* rcu_read_lock()ed by __nf_queue already. */
>   > 23		nfq_ct = rcu_dereference(nfq_ct_hook);
>     24		if (nfq_ct == NULL)
>     25			return NULL;
>     26	

JFYI: I've enqueued the following patch to fix this sparse warning:

http://1984.lsi.us.es/git/nf-next/commit/?id=5a05fae5ca7cd5279567747fc34d60413b504cd6
