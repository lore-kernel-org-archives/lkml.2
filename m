Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab0G1FC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:02:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:56613 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab0G1FCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:02:54 -0400
Subject: Re: [PATCH 05/16] x86, memblock: Add get_free_all_memory_range()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
In-Reply-To: <1279824241-17582-6-git-send-email-yinghai@kernel.org>
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>
	 <1279824241-17582-6-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:02:18 +1000
Message-ID: <1280293338.1970.235.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:43 -0700, Yinghai Lu wrote:
> 
> +       /* Take out region array itself at first*/
> +       if (memblock.reserved.regions != memblock_reserved_init_regions)
> +               memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
> +

More of that horror. Don't.

Another option from what i proposed earlier is to actually have a function
inside mm/memblock to free it (memblock_free_arrays()) that does nothing
if memblock is to survive init.

I hate exporting variables or data structures like that. Functions are
semantically a lot cleaner.

Ben.


