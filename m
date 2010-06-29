Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0F2Rqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:46:48 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8878 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab0F2Rqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:46:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 10/25] x86, lmb: Add lmb_to_bootmem()
Date: Tue, 29 Jun 2010 11:47:26 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-11-git-send-email-yinghai@kernel.org>
In-Reply-To: <1277227614-11581-11-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291147.27661.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 11:26:39 am Yinghai Lu wrote:
> +	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);

Please make all these address range messages match the %pR format.

> +	for_each_lmb(reserved, r) {
> +		pr_info("  [%010llx - %010llx] ", (u64)r->base, (u64)r->base + r->size);
> +		final_start = max(start, r->base);
> +		final_end = min(end, r->base + r->size);
> +		if (final_start >= final_end) {
> +			pr_cont("\n");
> +			continue;
> +		}
> +		pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
> +		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
> +	}
> +
> +	/* Put region array back ? */
> +	if (lmb.reserved.regions != lmb_reserved_init_regions)
> +		lmb_reserve(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
> +}
> +#endif
> 
