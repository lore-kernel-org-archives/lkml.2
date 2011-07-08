Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab1GHFZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:25:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:57268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab1GHFZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:25:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,498,1304319600"; 
   d="scan'208";a="27736898"
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, David Miller <davem@davemloft.net>,
        marcin.slusarz@gmail.com, mpm@selenic.com,
        linux-kernel@vger.kernel.org, rientjes@google.com, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <alpine.DEB.2.00.1107071511010.26083@router.home> (Christoph
	Lameter's message of "Thu, 7 Jul 2011 15:12:52 -0500 (CDT)")
References: <alpine.DEB.2.00.1107071314320.21719@router.home>
	<1310064771.21902.55.camel@jaguar>
	<alpine.DEB.2.00.1107071402490.24248@router.home>
	<20110707.122151.314840355798805828.davem@davemloft.net>
	<CAOJsxLFsX3Q84QAeyRt5dZOdRxb3TiABPrP-YrWc91+BmR8ZBg@mail.gmail.com>
	<alpine.DEB.2.00.1107071511010.26083@router.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Thu, 07 Jul 2011 22:23:45 -0700
Message-ID: <m2box5cplq.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:


> +#ifdef __HAVE_ARCH_INV_MEMSCAN
> +void *inv_memscan(void *addr, int c, size_t size)
> +{
> +	if (!size)
> +		return addr;
> +	asm volatile("repz; scasb\n\t"

This will just do the slow byte accesses again internally.
scasb is not normally very optimized in microcode as far
as I know.

Also rep has quite some startup overhead which makes
it a bad idea for small sizes (<16-20 or so)

I would stay with the C version. I bet that one is 
faster.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
