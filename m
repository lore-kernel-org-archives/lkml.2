Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2LCOBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:01:40 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:25528 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2LCOBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:01:38 -0500
Message-ID: <1354543290.7030.26.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] net/macb: Use dmapool to align descriptors on 64bits
From: Ben Hutchings <bhutchings@solarflare.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Joachim Eastwood <manabian@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date: Mon, 3 Dec 2012 14:01:30 +0000
In-Reply-To: <1354536914-6315-1-git-send-email-nicolas.ferre@atmel.com>
References: <1354536914-6315-1-git-send-email-nicolas.ferre@atmel.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 13:15 +0100, Nicolas Ferre wrote:
> Depending on datapath, some revisions of GEM need
> 64bits aligned descriptors. Use dmapool to allocate
> these descriptors.
> Note that different size between RX and TX rings
> leads to the creation of two pools.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
[...]

dma_alloc_coherent() allocates whole pages, which I think is quite
enough alignment.  You can't save memory by doing this, since each pool
needs at least one page.  So what is this change meant to achieve?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

