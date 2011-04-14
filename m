Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1DNVeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:34:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46844
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab1DNVeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:34:11 -0400
Date: Thu, 14 Apr 2011 14:33:35 -0700 (PDT)
Message-Id: <20110414.143335.104052252.davem@davemloft.net>
To: mgorman@suse.de
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH 08/12] netvm: Allow skb allocation to use PFMEMALLOC
 reserves
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302777698-28237-9-git-send-email-mgorman@suse.de>
References: <1302777698-28237-1-git-send-email-mgorman@suse.de>
	<1302777698-28237-9-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 14 Apr 2011 11:41:34 +0100

> +extern int memalloc_socks;
> +static inline int sk_memalloc_socks(void)
> +{
> +	return memalloc_socks;
> +}
> +
 ...
> +static DEFINE_MUTEX(memalloc_socks_lock);
> +int memalloc_socks __read_mostly;

Please use an atomic_t, it has to be more efficient than this mutex
business.
