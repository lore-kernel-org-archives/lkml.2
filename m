Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2B0GqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:46:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2B0GqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:46:21 -0500
Date: Mon, 27 Feb 2012 01:45:46 -0500 (EST)
Message-Id: <20120227.014546.2244934355313645351.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: paul.gortmaker@windriver.com, tim.bird@am.sony.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] mm: add a low limit to alloc_large_system_hash
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330322597.3330.5.camel@edumazet-laptop>
References: <CAP=VYLp7+Apubm=PHRLSw50V9zBKmV-xFRvcO4-qAogJVp7jcw@mail.gmail.com>
	<1330147182.2462.25.camel@edumazet-laptop>
	<1330322597.3330.5.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 26 Feb 2012 22:45:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 27 Feb 2012 07:03:17 +0100

> UDP stack needs a minimum hash size value for proper operation and also
> uses alloc_large_system_hash() for proper NUMA distribution of its hash
> tables and automatic sizing depending on available system memory.
> 
> On some low memory situations, udp_table_init() must ignore the
> alloc_large_system_hash() result and reallocs a bigger memory area.
> 
> As we cannot easily free old hash table, we leak it and kmemleak can
> issue a warning.
> 
> This patch adds a low limit parameter to alloc_large_system_hash() to
> solve this problem.
> 
> We then specify UDP_HTABLE_SIZE_MIN for UDP/UDPLite hash table
> allocation.
> 
> Reported-by: Mark Asselstine <mark.asselstine@windriver.com>
> Reported-by: Tim Bird <tim.bird@am.sony.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>

Who wants to take this?

