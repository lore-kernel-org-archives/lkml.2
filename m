Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2K2OzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:55:14 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:50526 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2K2OzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:55:12 -0500
Date: Thu, 29 Nov 2012 15:55:08 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nathan@traverse.com.au
Subject: Re: [PATCH] solos-pci: don't call vcc->pop() after pclose()
Message-ID: <20121129145508.GA16478@shrek.podlesie.net>
References: <1354039349.2534.11.camel@shinybook.infradead.org>
 <20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
 <AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
 <1354141115.21562.101.camel@shinybook.infradead.org>
 <20121129105715.GA10226@shrek.podlesie.net>
 <1354190143.21562.145.camel@shinybook.infradead.org>
 <20121129124344.GA7704@shrek.podlesie.net>
 <1354193837.21562.159.camel@shinybook.infradead.org>
 <20121129132021.GA15425@shrek.podlesie.net>
 <1354200137.21562.167.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354200137.21562.167.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:42:17PM +0000, David Woodhouse wrote:
> On Thu, 2012-11-29 at 14:20 +0100, Krzysztof Mazur wrote:
> >                 if (card->tx_skb[port] == skb) {
> >                         skb_get(skb);
> >                         solos_pop(SKB_CB(skb)->vcc, skb);
> >                         SKB_CB(skb)->vcc = NULL;
> 
> Um... yes, that would probably work. But it's subtle enough that it
> bothers me. And if it *did* cause any strange issues, it's a rare case
> and would be hard to reproduce/debug. Is it *really* necessary, just to
> speed up the vcc close? I'm inclined to stick with the 'KISS' approach.

That's why I proposed that simple loop that just calls ->pop() and
sets vcc to NULL.

Forget about that, Chas said that we cannot leave close() until we
close that vcc, so we really need to wait.

Krzysiek
