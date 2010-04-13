Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0DMD7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 23:59:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:39226 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0DMD7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 23:59:30 -0400
Subject: Re: [PATCH 06/39] lmb: Seperate __lmb_find_base() from
 __lmb_alloc_base()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1270793048-23796-7-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-7-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 13:58:01 +1000
Message-ID: <1271131081.13059.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:

> +	return -1ULL;
> +}

Defininf some kind of LMB_ERROR would be nicer.

Cheers,
Ben.

> +u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
> +{
> +	u64 base;
> +
> +	base = __lmb_find_base(size, align, max_addr);
> +
> +	if (base == -1ULL)
> +		return 0;
> +
> +	if (lmb_add_region(&lmb.reserved, base, size) < 0)
> +		return 0;
> +
> +	return base;
>  }
>  
>  /* You must call lmb_analyze() before this. */


