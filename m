Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2H0Rzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:55:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54267 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2H0Rzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:55:45 -0400
Message-ID: <503BB49C.5010402@lwfinger.net>
Date: Mon, 27 Aug 2012 12:55:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, ncardwell@google.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
References: <50369925.3050705@lwfinger.net>  <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net>  <20120824.111948.680531915905273128.davem@davemloft.net>  <5037A4B0.3080208@lwfinger.net>  <1345825095.19483.19.camel@edumazet-glaptop>  <1345825432.19483.20.camel@edumazet-glaptop>  <5037B2AC.50704@lwfinger.net> <1345830424.19483.69.camel@edumazet-glaptop>
In-Reply-To: <1345830424.19483.69.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 12:47 PM, Eric Dumazet wrote:
>
> dev_alloc_skb() can return NULL
>
> -> crash
>
> skb_clone() can also return NULL
>
> -> crash

I have prepared a patch to fix all the unchecked allocations.

Over the weekend I made some progress. To test the latest vendor driver, I 
installed a 32-bit system. Their driver is not compatible with a 64-bit system. 
I found that not only did the vendor driver work with secure sites, but so did 
the in-kernel version. I now have tcpdump output for the 32-bit case that works, 
and the 64-bit case that fails. It seems likely that I missed some 32/64 bit 
incompatibility when I did the conversion.

Thanks for all your help in trying to resolve this issue.

Larry


