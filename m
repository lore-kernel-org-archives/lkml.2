Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1H1VQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 17:16:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54434 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1H1VQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 17:16:42 -0400
Date: Sun, 28 Aug 2011 17:16:28 -0400 (EDT)
Message-Id: <20110828.171628.554738440008982339.davem@davemloft.net>
To: joe@perches.com
Cc: akpm@linux-foundation.org, sjur.brandeland@stericsson.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH] caif: Remove OOM messages, use kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1314314545.4637.19.camel@Joe-Laptop>
References: <1314305243.4637.10.camel@Joe-Laptop>
	<20110825150456.fc8720c4.akpm@linux-foundation.org>
	<1314314545.4637.19.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 28 Aug 2011 14:16:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 25 Aug 2011 16:22:24 -0700

> Remove per site OOM messages because they duplicate
> the generic mm subsystem OOM message.
> 
> Use kzalloc instead of kmalloc/memset
> when next to the OOM message removals.
> 
> Reduces object size (allyesconfig ~2%)
> 
> $ size -t drivers/net/caif/built-in.o.old net/caif/built-in.o.old
>    text	   data	    bss	    dec	    hex	filename
>   32297	    700	   8224	  41221	   a105	drivers/net/caif/built-in.o.old
>   72159	   1317	  20552	  94028	  16f4c	net/caif/built-in.o.old
>  104456	   2017	  28776	 135249	  21051	(TOTALS)
> $ size -t drivers/net/caif/built-in.o.new net/caif/built-in.o.new
>    text	   data	    bss	    dec	    hex	filename
>   31975	    700	   8184	  40859	   9f9b	drivers/net/caif/built-in.o.new
>   70748	   1317	  20152	  92217	  16839	net/caif/built-in.o.new
>  102723	   2017	  28336	 133076	  207d4	(TOTALS)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good to me, applied, thanks Joe.
