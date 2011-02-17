Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1BQXLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:11:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48357
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924Ab1BQXLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:11:12 -0500
Date: Thu, 17 Feb 2011 15:11:47 -0800 (PST)
Message-Id: <20110217.151147.35033921.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: xiyou.wangcong@gmail.com, cypher.w@gmail.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: IGMP and rwlock: Dead ocurred again on TILEPro
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D5DA96D.5060200@tilera.com>
References: <4D5DA60A.8080201@tilera.com>
	<20110217.145333.232751283.davem@davemloft.net>
	<4D5DA96D.5060200@tilera.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 17 Feb 2011 18:04:13 -0500

> On 2/17/2011 5:53 PM, David Miller wrote:
>> From: Chris Metcalf <cmetcalf@tilera.com>
>> Date: Thu, 17 Feb 2011 17:49:46 -0500
>>
>>> The fix is to disable interrupts for the arch_read_lock family of methods. 
>> How does that help handle the race when it happens between different
>> cpus, instead of between IRQ and non-IRQ context on the same CPU?
> 
> There's no race in that case, since the lock code properly backs off and
> retries until the other cpu frees it.  The distinction here is that the
> non-IRQ context is "wedged" by the IRQ context.
> 
>> Why don't you just use the generic spinlock based rwlock code on Tile,
>> since that is all that your atomic instructions can handle
>> sufficiently?
> 
> The tile-specific code encodes reader/writer information in the same 32-bit
> word that the test-and-set instruction manipulates, so it's more efficient
> both in space and time.  This may not really matter for rwlocks, since no
> one cares much about them any more, but that was the motivation.

Ok, but IRQ disabling is going to be very expensive.
