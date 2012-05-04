Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2EDGm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:42:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50650 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2EDGm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:42:28 -0400
Date: Fri, 04 May 2012 02:42:16 -0400 (EDT)
Message-Id: <20120504.024216.1730395431103337434.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <201205031936.q43Ja9Xb031644@lab-41.internal.tilera.com>
References: <201205011759.q41HxR21020043@farm-0012.internal.tilera.com>
	<20120503.014156.149171097979026872.davem@davemloft.net>
	<201205031936.q43Ja9Xb031644@lab-41.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 May 2012 23:42:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 3 May 2012 12:41:56 -0400

> +/* First, "tile_net_init_module()" initializes each network cpu to
> + * handle incoming packets, and initializes all the network devices.
> + *
> + * Then, "ifconfig DEVICE up" calls "tile_net_open()", which will
> + * turn on packet processing, if needed.
> + *
> + * If "ifconfig DEVICE down" is called, it uses "tile_net_stop()" to
> + * stop egress, and possibly turn off packet processing.
> + *
> + * We start out with the ingress IRQ enabled on each CPU.  When it
> + * fires, it is automatically disabled, and we call "napi_schedule()".
> + * This will cause "tile_net_poll()" to be called, which will pull
> + * packets from the netio queue, filtering them out, or passing them
> + * to "netif_receive_skb()".  If our budget is exhausted, we will
> + * return, knowing we will be called again later.  Otherwise, we
> + * reenable the ingress IRQ, and call "napi_complete()".

This is not the place where you document how the generic networking
brings devices up and down, and what driver methods are called during
those actions.

Imagine if every driver writer decided to do this.

> +#define TILE_NET_MAX_COMPS 64
> +
> +

Please get rid of all of these more-than-one empty line sequences.

> +#define ROUND_UP(n, align) (((n) + (align) - 1) & -(align))

This is ALIGN() from linux/kernel.h, please us it.

At this rate I anticipate at least 20 rounds of review, this driver
still needs quite a bit of work.
