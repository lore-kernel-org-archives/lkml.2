Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0KYRNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:13:21 -0500
Received: from netnation.com ([204.174.223.2]:56883 "EHLO peace.netnation.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab0KYRNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:13:20 -0500
Date: Thu, 25 Nov 2010 09:13:13 -0800
From: Simon Kirby <sim@hostway.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Free memory never fully used, swapping
Message-ID: <20101125171313.GA15899@hostway.ca>
References: <1290647274.12777.3.camel@sli10-conroe> <20101125090328.GB14180@hostway.ca> <20101125191759.F465.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125191759.F465.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 07:18:49PM +0900, KOSAKI Motohiro wrote:

> This?

> -	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
> +	alloc_gfp = (flags | __GFP_NOWARN) & ~(__GFP_NOFAIL | __GFP_WAIT);

kswapd still gets woken in the !__GFP_WAIT case, which is what I was
seeing anyway, because the order-3 allocatons were starting from
__alloc_skb().

Simon-
