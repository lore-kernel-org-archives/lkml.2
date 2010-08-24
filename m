Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab0HXH3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:29:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37639 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0HXH3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:29:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Aug 2010 16:24:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 2/6] mm: stack based kmap_atomic
Message-Id: <20100824162427.58e2eb88.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100819202753.656285068@chello.nl>
References: <20100819201317.673172547@chello.nl>
	<20100819202753.656285068@chello.nl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 22:13:19 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Keep the current interface but ignore the KM_type and use a stack
> based approach.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
 
> +DECLARE_PER_CPU(int, __kmap_atomic_idx);
> +
> +static inline int kmap_atomic_idx_push(void)
> +{
> +	int idx = __get_cpu_var(__kmap_atomic_idx)++;
> +#ifdef CONFIG_DEBUG_HIGHMEM
> +	BUG_ON(idx > KM_TYPE_NR);
> +#endif
> +	return idx;
> +}
> +
> +static inline int kmap_atomic_idx_pop(void)
> +{
> +	int idx = --__get_cpu_var(__kmap_atomic_idx);
> +#ifdef CONFIG_DEBUG_HIGHMEM
> +	BUG_ON(idx < 0);
> +#endif
> +	return idx;
> +}
> +
>  #else /* CONFIG_HIGHMEM */
> 

I may don't understand anything... Is irq already disabled ?
And Is it documented that kmap_atomic shouln't be used under NMI or something
special interrupts ?

Thanks,
-Kame


