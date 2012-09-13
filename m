Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2IMJmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:42:12 -0400
Received: from mail.us.es ([193.147.175.20]:43299 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab2IMJmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:42:09 -0400
Date: Thu, 13 Sep 2012 11:42:05 +0200
From: Pablo Neira Ayuso <pablo@gnumonks.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Patrick McHardy <kaber@trash.net>,
        networking <netdev@vger.kernel.org>,
        "Netfilter Development Maili..." <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xt_nat_init: BUG: unable to handle kernel NULL pointer
 dereference at 00000000000000e0
Message-ID: <20120913094205.GA30612@1984>
References: <20120913091629.GA28022@localhost>
 <20120913093024.GL14750@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913093024.GL14750@breakpoint.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:30:24AM +0200, Florian Westphal wrote:
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hi Patrick,
> > 
> > This happens in today's linux-next tree and is pretty reproducible.
> > [    1.834544] nf_conntrack version 0.5.0 (1786 buckets, 7144 max)
> > [    1.835406] ctnetlink v0.93: registering with nfnetlink.
> > [    1.836202] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
> > [    1.837539] IP: [<ffffffff81a19123>] mutex_lock_interruptible+0x23/0x70
> 
> Should be fixed by
> commit 00545bec9412d130c77f72a08d6c8b6ad21d4a1e
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Subject: netfilter: fix crash during boot if NAT has been compiled built-in
> 
> But seems its not yet in net-next.  Pablo?

I'll request the pull asap.
