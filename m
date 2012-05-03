Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2ECFmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:42:05 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39939 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2ECFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 01:42:03 -0400
Date: Thu, 03 May 2012 01:41:56 -0400 (EDT)
Message-Id: <20120503.014156.149171097979026872.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <201205011759.q41HxR21020043@farm-0012.internal.tilera.com>
References: <201204291859.q3TIxIWB007275@farm-0027.internal.tilera.com>
	<201204301435.08810.arnd@arndb.de>
	<201205011759.q41HxR21020043@farm-0012.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 02 May 2012 22:41:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 17 Sep 2001 00:00:00 -0400

> +/* #define USE_SIM_PRINTF */
> +
> +#ifdef USE_SIM_PRINTF
> +
> +static __attribute__((unused, format (printf, 1, 2))) void
> +sim_printf(const char *format, ...)
 ...
> +/* HACK: Allow use of "sim_printf()" instead of "printk()". */
> +#define printk sim_printf
> +
> +#endif

This doesn't belong in a driver.

You want a debugging console driver that uses that special SIM output
facility instead.

Therefore, please remove this sim_printf stuff completely.
