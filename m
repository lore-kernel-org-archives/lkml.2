Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2IMJag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:30:36 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53802 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922Ab2IMJaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:30:30 -0400
Date: Thu, 13 Sep 2012 11:30:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Patrick McHardy <kaber@trash.net>, networking <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@gnumonks.org>,
        "Netfilter Development Maili..." <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xt_nat_init: BUG: unable to handle kernel NULL pointer
 dereference at 00000000000000e0
Message-ID: <20120913093024.GL14750@breakpoint.cc>
References: <20120913091629.GA28022@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913091629.GA28022@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Patrick,
> 
> This happens in today's linux-next tree and is pretty reproducible.
> [    1.834544] nf_conntrack version 0.5.0 (1786 buckets, 7144 max)
> [    1.835406] ctnetlink v0.93: registering with nfnetlink.
> [    1.836202] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
> [    1.837539] IP: [<ffffffff81a19123>] mutex_lock_interruptible+0x23/0x70

Should be fixed by
commit 00545bec9412d130c77f72a08d6c8b6ad21d4a1e
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: netfilter: fix crash during boot if NAT has been compiled built-in

But seems its not yet in net-next.  Pablo?
