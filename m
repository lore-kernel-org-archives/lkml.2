Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab1ELVgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:36:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab1ELVgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:36:13 -0400
Date: Thu, 12 May 2011 17:36:08 -0400 (EDT)
Message-Id: <20110512.173608.1652572492952866283.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: af_packet: Don't initialize vnet_hdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305236000.6124.67.camel@Joe-Laptop>
References: <18a010357eb63dfd50751c5eb529f6261cf90ecd.1305232529.git.joe@perches.com>
	<20110512.172623.220889608152651989.davem@davemloft.net>
	<1305236000.6124.67.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:36:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 14:33:20 -0700

> On Thu, 2011-05-12 at 17:26 -0400, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Thu, 12 May 2011 13:36:10 -0700
>> 
>> > Save a memset, initialize only the portion necessary.
>> > 
>> > packet_snd either gets this structure completely from
>> > memcpy_fromiovec or uses only the hdr_len set to 0,
>> > so don't always initialize the structure to 0.
>> > 
>> > Signed-off-by: Joe Perches <joe@perches.com>
>> 
>> On ARM this won't be tightly packed, therefore you'll leave
>> uninitialized pieces of padding in this structure and this
>> thing is an "on-the-wire" network header.
>> 
>> I'm not applying this.
> 
> I believe that it's only sent when po->has_vnet_hdr
> is set.  In that case, it's completely filled from
> memcpy_fromiovec.  In the not set po->has_vnet_hdr case,
> only vnet_hdr.hdr_len is accessed by packet_alloc_skb.

I think with the way this code is protecting accesses to vnet_hdr,
it's going to start warning that some parts "may" be use
uninitialized.

It's also slightly ugly to partially initialize these on-stack things.

I would rather see the code rearranged such that this sort of
hackish scheme isn't necessary.

Again, I'm not applying this.
