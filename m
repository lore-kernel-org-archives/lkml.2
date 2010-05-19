Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0EST4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:56:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32879
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab0EST4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:56:21 -0400
Date: Wed, 19 May 2010 12:56:30 -0700 (PDT)
Message-Id: <20100519.125630.121263182.davem@davemloft.net>
To: cl@linux.com
Cc: lethal@linux-sh.org, penberg@cs.helsinki.fi, mpm@selenic.com,
       herbert@gondor.hengli.com.au, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp, dwmw2@infradead.org
Subject: Re: [BUG] SLOB breaks Crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1005191017290.4592@router.home>
References: <20100518223507.GB5933@linux-sh.org>
	<20100518223739.GC5933@linux-sh.org>
	<alpine.DEB.2.00.1005191017290.4592@router.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>
Date: Wed, 19 May 2010 10:19:33 -0500 (CDT)

> The assumptions are not arbitrary. It is reasonable to assume that
> structures managed by the slab allocators may contain long long variables
> and that therefore a unsigned long long alignment is required by the
> allocator. It is the *compiler* who tells us that long long needs to be
> aligned at double word boundaries. If an arch does not require long long
> alignment on double word boundaries then the *compiler* should tell us
> that and then the allocators will align on word boundaries.

That is a good point.

So really, __alignof__(unsigned long long) is technically always right.
Because it should evaluate to "4" on x86-32, for example.
