Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1KBXOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:14:21 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61835 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1KBXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:14:18 -0400
Message-ID: <4EB1CEC4.3090909@gmail.com>
Date: Thu, 03 Nov 2011 00:14:12 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tony@atomide.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: Add back alignment for size for __alloc_skb
References: <20111102224317.GM31337@atomide.com> <4EB1CA4F.3090403@gmail.com> <20111102.190955.1902322759075682192.davem@davemloft.net>
In-Reply-To: <20111102.190955.1902322759075682192.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 00:09, David Miller wrote:

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Wed, 02 Nov 2011 23:55:11 +0100
> 
>> There is a problem with your kmalloc() or alignments on your architecture.
>>
>> What is the SMP_CACHE_BYTES value ?
> 
> kmalloc() behavior doesn't have anything to do with this bug.
> 
> The issue is calculation of skb->end, which is based upon calculated
> 'size' variable.
> 
> skb->end determines alignment of skb_shared_info, which is where the
> alignment problem is occuring for Tony.
> 


I understood that David, but check the code, and you can see that exact
skb->end depends also on ksize()

So maybe the right fix is to make sure skb->end is properly aligned, say
with SLOB

So a more generic fix is welcomed.

