Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2G0Ubj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:31:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36582 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2G0Ubi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:31:38 -0400
Date: Fri, 27 Jul 2012 13:31:35 -0700 (PDT)
Message-Id: <20120727.133135.2017747630291360657.davem@davemloft.net>
To: jkosina@suse.cz
Cc: christopher.leech@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jbohac@suse.cz
Subject: Re: [PATCH] tcp: perform DMA to userspace only if there is a task
 waiting for it
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1207271556320.11375@pobox.suse.cz>
References: <alpine.LNX.2.00.1207271556320.11375@pobox.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Fri, 27 Jul 2012 16:05:06 +0200 (CEST)

>  #ifdef CONFIG_NET_DMA
> -				if (tcp_dma_try_early_copy(sk, skb, tcp_header_len)) {
> +				if (tp->ucopy.task == current &&
> +						sock_owned_by_user(sk) &&
> +						tcp_dma_try_early_copy(sk,
> +							skb, tcp_header_len)) {

This indentation is absolutely terrible.

If you are only able to indent lines using TAB characters, rather than
using an appropriate mixture of TAB and SPACE characters to get the
lines to line up properly, please do not even bother submitting
patches here.
