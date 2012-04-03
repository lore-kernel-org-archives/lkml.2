Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab2DCWXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:23:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38927 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab2DCWXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:23:41 -0400
Date: Tue, 03 Apr 2012 18:23:35 -0400 (EDT)
Message-Id: <20120403.182335.782073108961783777.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tilepro ethernet driver: fix a few minor issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <201203302325.q2UNPm8j012403@farm-0012.internal.tilera.com>
References: <201203302325.q2UNPm8j012403@farm-0012.internal.tilera.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 15:23:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 19:23:35 -0400

> This commit fixes a number of issues seen with the driver:
> 
> - Improve handling of return credits to the hardware shim
> - Use skb_frag_size() appropriately
> - Add netpoll support to run console over UDP
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Please do not mix pure bug fixes and new features.

Submit the pure bug fixes separately for 'net' tree submission
and then submit feature additions like netpoll support in
a patch targetting the 'net-next' tree.

> +	/* Handle completions if needed to make room. */
> +	/* NOTE: Return NETDEV_TX_BUSY if there is still no room. */

Do not format comments like this, use something like this instead:

	/* Handle completions if needed to make room.
	 * NOTE: Return NETDEV_TX_BUSY if there is still no room.
	 */

>  	/* Prepare to advance, detecting full queue. */
> +	/* NOTE: Return NETDEV_TX_BUSY if the queue is full. */

Similarly, combine them up into a single comment.

> +	/* Handle completions if needed to make room. */
> +	/* NOTE: Return NETDEV_TX_BUSY if there is still no room. */

Same here.

>  	/* Copy the commands, or fail. */
> +	/* NOTE: Return NETDEV_TX_BUSY if the queue is full. */

Again.

> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +/*
> + * Polling 'interrupt' - used by things like netconsole to send skbs

Format the comment:

	/* Like
	 * this.
	 */

not:

	/*
	 * Like
	 * this.
	 */
