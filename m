Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2BWAAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:00:55 -0500
Received: from ja.ssi.bg ([178.16.129.10]:33664 "EHLO ja.ssi.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab2BWAAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:00:54 -0500
Date: Thu, 23 Feb 2012 02:02:16 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Arun Sharma <asharma@fb.com>
cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: route add default fails with ESRCH?
In-Reply-To: <4F45638B.30305@fb.com>
Message-ID: <alpine.LFD.2.00.1202230129440.1603@ja.ssi.bg>
References: <4F3F0158.2020406@fb.com> <4F4541E5.5040700@fb.com> <alpine.LFD.2.00.1202222319150.1603@ja.ssi.bg> <4F45638B.30305@fb.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 22 Feb 2012, Arun Sharma wrote:

> Without this my eth0 driver complains about link not being ready.
> 
> > > # cat /proc/net/fib_trie
> > 
> > 	Where is "Main:" here?
> 
> I think answering this is key.

	Main is not printed only when the main table is
empty. The table name is printed only if there are nodes
in the table. May be all rules (ESRCH) and all routes (no Main)
are flushed.

> This is the main difference between systems that work and the ones that don't.
> Systems that work have a non-empty Main table:
> 
> # cat /proc/net/fib_trie
> Main:
>   +-- 0.0.0.0/0 4 3 10
>      +-- 0.0.0.0/4 1 0 0
>         |-- 0.0.0.0
>            /0 universe THROW
> 
> I'll try to figure out why my RT_TABLE_MAIN was empty after my network startup
> scripts finished. But given my experience with 2.6.38, fib_hash handled this
> case just fine and fib_trie broke it :(

	printk for current->comm should show the process name
that removes the routes. If problem is ifup-local I remember
only for one difference: fib_trie can list 0.0.0.0/0 before
other routes but ip route flush default simply removes all
routes, even on old kernels. May be route del default gw...
does not delete the default route and then
'ip route flush default' does the bad job.

Regards

--
Julian Anastasov <ja@ssi.bg>
