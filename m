Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1HaOxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:53:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1HaOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:53:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 28/35] Hexagon: Add ioremap support
Date: Wed, 31 Aug 2011 16:53:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190802.372848298@codeaurora.org>
In-Reply-To: <20110830190802.372848298@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311653.37970.arnd@arndb.de>
X-Provags-ID: V02:K0:MTZtk0vHPMXKewtrgH5Esy9TiTPo4rkJOR7DQ9ji99p
 McmdMJhD4dXEq34KcbFoqmmp9eO2uKnZLIQpzf3i5eJrws0x+u
 BmaOb/teLBN5IsF6kC5gaboqxhkoVh9w8eB9gkJpCBayCnvBF8
 L4Bb97b1od4X0pQZu+WSLQzw1q1fifBiwjDmSHZyCy4j9hYeLa
 BjUz507eWSzt0MLlPxyJTkzUwi7av7BPiH9i0+WoIXhLsIOMA3
 +DzkHeaeWQl1wtra8TaYljWIR3E4HxJ9kebxOiN4fJVi5nYmmh
 J82OsqZZEDl73Li7fh0SkuX04qh2n9zUkP+PMXgWHvvYxu6nHp
 if2TJYFkP3XA1CyHsV50=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> +       if (ioremap_page_range(addr, addr+size, phys_addr, prot)) {
> +               vunmap((void *)addr);
> +               return NULL;
> +       }
> +
> +       flush_cache_vmap(addr, addr+size);

I think that ioremap_page_range implies the flush_cache_vmap already,
so there is no reason to do it again.

	Arnd
