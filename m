Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0KZAdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 19:33:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53203 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0KZAdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 19:33:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Simon Kirby <sim@hostway.ca>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Shaohua Li <shaohua.li@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20101125171313.GA15899@hostway.ca>
References: <20101125191759.F465.A69D9226@jp.fujitsu.com> <20101125171313.GA15899@hostway.ca>
Message-Id: <20101126093326.B6D0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Nov 2010 09:33:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 25, 2010 at 07:18:49PM +0900, KOSAKI Motohiro wrote:
> 
> > This?
> 
> > -	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
> > +	alloc_gfp = (flags | __GFP_NOWARN) & ~(__GFP_NOFAIL | __GFP_WAIT);
> 
> kswapd still gets woken in the !__GFP_WAIT case, which is what I was
> seeing anyway, because the order-3 allocatons were starting from
> __alloc_skb().

Oops, my fault.
We also need __GFP_NOKSWAPD. (Proposed by Andrea)


