Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab0JSLFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:05:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38820 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab0JSLFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:05:04 -0400
Date: Tue, 19 Oct 2010 07:04:52 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: luca@llucax.com.ar, paul.gortmaker@windriver.com, jon.maloy@ericsson.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Message-ID: <20101019110452.GA14410@hmsreliant.think-freely.org>
References: <4CBCD429.8090306@windriver.com>
 <20101018234547.GA5703@hmsreliant.think-freely.org>
 <20101019021657.GZ8781@llucax.com.ar>
 <20101019.011649.71113115.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019.011649.71113115.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:16:49AM -0700, David Miller wrote:
> From: Leandro Lucarella <luca@llucax.com.ar>
> Date: Mon, 18 Oct 2010 23:16:57 -0300
> 
> > 
> > The problem is not between the tipc stacks in different hosts, is
> > between the tipc stack and the applications using it (well, maybe
> > there is a problem somewhere else too).
> > 
> > This was a deliberate API change, not a subtle bug...
> 
> Neil et al., if these packets live only between the kernel stack
> and the userspace API layer, we should not be byte-swapping this
> stuff and we need to fix this fast.
> 
Copy that Dave.  I think I see the problem.  The subscription code handles
messages both off the wire and from local user space.  The off the wire case
should work because the subscription code assumes that all the incomming data is
in network byte order, but user space is an exception to that rule as its in
local byte order.  I'll have a patch together for Leandro to test soon.
Neil

> Thanks.
> 
