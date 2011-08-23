Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1HWAAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:00:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56489 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1HWAAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:00:31 -0400
Date: Mon, 22 Aug 2011 17:00:20 -0700 (PDT)
Message-Id: <20110822.170020.2116490055045958490.davem@davemloft.net>
To: Ian.Campbell@eu.citrix.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl
Subject: Re: [PATCH] net: add APIs for manipulating skb page fragments.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313915037.17978.686.camel@dagon.hellion.org.uk>
References: <1313771100-22993-1-git-send-email-ian.campbell@citrix.com>
	<20110820.173133.1612902138924735868.davem@davemloft.net>
	<1313915037.17978.686.camel@dagon.hellion.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 22 Aug 2011 17:00:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@eu.citrix.com>
Date: Sun, 21 Aug 2011 09:23:57 +0100

> On Sun, 2011-08-21 at 01:31 +0100, David Miller wrote:
>> From: Ian Campbell <ian.campbell@citrix.com>
>> Date: Fri, 19 Aug 2011 17:25:00 +0100
>> 
>> > The primary aim is to add skb_frag_(ref|unref) in order to remove the use of
>> > bare get/put_page on SKB pages fragments and to isolate users from subsequent
>> > changes to the skb_frag_t data structure.
>> > 
>> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> 
>> You're going to have to protect all of the things using the interfaces
>> from linux/dma-mapping.h with CONFIG_HAS_DMA otherwise it won't build
>> on platforms like S390.
> 
> s390 is one of the arches which I build tested and I initially saw this
> issue too. I did add CONFIG_HAS_DMA but it turns out that
> linux/dma-mapping.h takes care of this by including
> asm-generic/dma-mapping-broken.h for you so I removed the #ifdef again.
> The header defines the prototypes to allow building but causes a link
> time failure if anything actually uses the interfaces.
> 
> I just tested a s390x defconfig build again and it appears to be fine.

Thanks for explaining this.

Patch applied, thanks!
