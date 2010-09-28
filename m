Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0I1VYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:24:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36734 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0I1VYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:24:30 -0400
Date: Tue, 28 Sep 2010 22:24:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Julia Lawall <julia@diku.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
Message-ID: <20100928212417.GF19804@ZenIV.linux.org.uk>
References: <4CA09977.80506@panasas.com>
 <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
 <20100928211106.GE19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928211106.GE19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 10:11:06PM +0100, Al Viro wrote:

> IOW, it _must_ use the last one in such cases.
> 
> As for the driver, I smell an interface change (in eth_mac_addr() arguments)
> that has been missed...  FWIW, grep through the tree shows one more instance
> of eth_mac_addr() called with such argument and it's also in net_kern.c; there
> we simply want memcpy() instead, since device is definitely not running at
> that point and we'd done the validity checks earlier.
> 
> Not sure if we need lp->lock around that eth_mac_addr() call - not familiar
> with the driver in question.  If we don't, we should switch to eth_mac_addr
> for the method, indeed...

FWIW, after looking at that code... I don't think we need lp->lock there,
but I really wonder if we need to update lp->mac as well, or, perhaps simply
remove it completely.  Who maintains these drivers?  It's not just
net_kern/net_user; there's a bunch of subdrivers for that sucker...
