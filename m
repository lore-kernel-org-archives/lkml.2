Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab1ELWAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:00:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab1ELWAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:00:02 -0400
Date: Thu, 12 May 2011 17:59:59 -0400 (EDT)
Message-Id: <20110512.175959.1343349350164758016.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: af_packet: Don't initialize vnet_hdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305237348.6124.72.camel@Joe-Laptop>
References: <1305236000.6124.67.camel@Joe-Laptop>
	<20110512.173608.1652572492952866283.davem@davemloft.net>
	<1305237348.6124.72.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 15:00:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 14:55:48 -0700

> Save an initialization because when this structure
> is used it's completely filled by memcpy_fromiovec.
> 
> Add a new variable used for the 0 sized allocation
> when this structure is not used.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
> On Thu, 2011-05-12 at 17:36 -0400, David Miller wrote:
>> I would rather see the code rearranged such that this sort of
>> hackish scheme isn't necessary.

You misunderstood me.

It's this:

	struct virtio_net_hdr vnet_hdr;


	if (po->has_vnet_hdr) {
		initialize &vnet_hdr
	}

	...

	if (po->has_vnet_hdr) {
		use vnet_hdr
	}

which I'm talking about when I say "hackish scheme".

The compiler cannot conclusively see that the control flow always
goes to the code that initialized vnet_hdr every time it reaches
the code that uses it.

I want _that_ part rearranged, not what you decided to tackle
here.

For the third time, I'm not applying your patch.
