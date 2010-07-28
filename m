Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0G1JaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:30:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:59078 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab0G1JaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:30:04 -0400
Subject: Re: [PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Miller <davem@davemloft.net>, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <4C4FCA7A.1020506@kernel.org>
References: <1280294128.1970.237.camel@pasglop>
	 <1280294376.1970.239.camel@pasglop>	<4C4FC5D1.3070708@zytor.com>
	 <20100727.230120.43037767.davem@davemloft.net>
	 <4C4FCA7A.1020506@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 19:29:02 +1000
Message-ID: <1280309342.1970.283.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 23:13 -0700, Yinghai Lu wrote:
> So still keep MEMBLOCK_ERROR to (~(phys_addr_t)0) ?

No point for now. lmb_alloc() etc... are defined as returning 0 for
failure so we would need to fix that too.

As I said in a previous email we do need to revisit the memblock error
handling.

> We can change some variable from unsigned long to phys_addr_t that
> will be assigned by memblock_find_base().
> 
> that could avoid casting too. 

That would be a good idea anyways if those are indeed carrying a
physical address.

Ben.


