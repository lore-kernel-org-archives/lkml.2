Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab2LZXN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 18:13:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36068 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2LZXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 18:13:56 -0500
Date: Wed, 26 Dec 2012 15:13:55 -0800 (PST)
Message-Id: <20121226.151355.2215825989495032073.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH BUGFIX] pkt_sched: fix little service anomalies and
 possible crashes of qfq+
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355938266-18459-1-git-send-email-paolo.valente@unimore.it>
References: <1355938266-18459-1-git-send-email-paolo.valente@unimore.it>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo valente <paolo.valente@unimore.it>
Date: Wed, 19 Dec 2012 18:31:06 +0100

> +	/*
> +	 * The next assignment may let
> +	 * agg->initial_budget > agg->budgetmax
> +	 * hold, but this does not cause any harm
> +	 */

Please format comments in the networking:

	/* Like
	 * this.
	 */

and

	/*
	 * Never
	 * like this.
	 */

I know this file is full of exceptions, but that error is to be
corrected rather than expanded.

> +	/*
> +	 * If lmax is lowered, through qfq_change_class, for a class
> +	 * owning pending packets with larger size than the new value of lmax,
> +	 * then the following condition may hold.
> +	 */

Likewise.

And I'm not applying this until someone familiar with this code
does some review of this patch.  These are seriously non-trivial
changes.
