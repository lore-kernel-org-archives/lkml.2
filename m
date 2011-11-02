Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1KBXRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:17:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36808 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1KBXRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:17:20 -0400
Date: Wed, 02 Nov 2011 19:17:16 -0400 (EDT)
Message-Id: <20111102.191716.1682282796914825621.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: tony@atomide.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: Add back alignment for size for __alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <4EB1CEC4.3090909@gmail.com>
References: <4EB1CA4F.3090403@gmail.com>
	<20111102.190955.1902322759075682192.davem@davemloft.net>
	<4EB1CEC4.3090909@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 02 Nov 2011 16:17:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c> 
> The issue is calculation of skb->end, which is based upon calculated
> 'size' variable.
> 
> skb->end determines alignment of skb_shared_info, which is where the
> alignment problem is occuring for Tony.

Right, and SMP_CACHE_BYTES setting should save us in any case.

For ARM, SMP_CACHE_BYTES seems to be set to L1_CACHE_BYTES which in
turn is set via ARM_L1_CACHE_SHIFT which can be set seemingly to any
value but the defaults are 5 and 6 which should be OK.

So unless Tony is using a non-standard setting of ARM_L1_CACHE_SHIFT,
this report is a bit mysterious.
