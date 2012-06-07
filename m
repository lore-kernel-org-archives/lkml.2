Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2FGAo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:44:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48131 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2FGAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:44:26 -0400
Date: Wed, 6 Jun 2012 20:37:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-mm@kvack.org
Subject: Re: frontswap: is frontswap_init called from swapoff safe?
Message-ID: <20120607003720.GI9472@phenom.dumpdata.com>
References: <4FCDE270.1020906@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCDE270.1020906@cesarb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 07:41:52AM -0300, Cesar Eduardo Barros wrote:
> I was looking at the swapfile.c parts of the recently-merged
> frontswap, and noticed that frontswap_init can be called from
> swapoff when try_to_unuse fails.
> 
> This looks odd to me. Whether it is safe or not depends on what
> frontswap_ops.init does, but the comment for __frontswap_init
> ("Called when a swap device is swapon'd") and the function name
> itself seem to imply it should be called only for swapon, not when
> relinking the swap_info after a failed swapoff.

<nods>
> 
> In particular, if frontswap_ops.init assumes the swap map is empty,
> it would break, since as far as I know when try_to_unuse fails there
> are still pages in the swap.

Let me look at this - can't do it this week - but will get back to you
shortly.
> 
> (By the way, the comment above enable_swap_info at sys_swapoff needs
> to be updated to also explain why reading p->frontswap_map outside
> the lock is safe at that point, like it does for p->prio and
> p->swap_map.)
> 
> -- 
> Cesar Eduardo Barros
> cesarb@cesarb.net
> cesar.barros@gmail.com
