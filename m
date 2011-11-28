Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1K1XIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:08:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab1K1XIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:08:23 -0500
Date: Mon, 28 Nov 2011 18:08:07 -0500 (EST)
Message-Id: <20111128.180807.649757269111867027.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: anton@samba.org, levinsasha928@gmail.com, mpm@selenic.com,
        cl@linux-foundation.org, penberg@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mihai.maruseac@gmail.com
Subject: Re: [PATCH] net: Fix corruption in /proc/*/net/dev_mcast
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322474116.2292.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111128181446.2ab784d0@kryten>
	<1322474116.2292.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 28 Nov 2011 15:08:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 28 Nov 2011 10:55:16 +0100

>> With slub debugging on I see red zone issues in /proc/*/net/dev_mcast:
>> 
>> =============================================================================
>> BUG kmalloc-8: Redzone overwritten
>> -----------------------------------------------------------------------------
 ...
>> dev_mc_seq_ops uses dev_seq_start/next/stop but only allocates
>> sizeof(struct seq_net_private) of private data, whereas it expects
>> sizeof(struct dev_iter_state):
>> 
>> struct dev_iter_state {
>> 	struct seq_net_private p;
>> 	unsigned int pos; /* bucket << BUCKET_SPACE + offset */
>> };
>> 
>> Create dev_seq_open_ops and use it so we don't have to expose
>> struct dev_iter_state.
>> 
>> Signed-off-by: Anton Blanchard <anton@samba.org>
 ...
> Problem added by commit f04565ddf52e4 (dev: use name hash for
> dev_seq_ops)
> 
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Mihai Maruseac <mihai.maruseac@gmail.com>

Applied, thanks everyone.
