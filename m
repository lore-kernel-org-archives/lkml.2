Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab2HWU5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:57:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59755 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab2HWU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:57:14 -0400
Message-ID: <50369925.3050705@lwfinger.net>
Date: Thu, 23 Aug 2012 15:57:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
References: <50345B12.1050600@lwfinger.net>  <1345612503.5158.566.camel@edumazet-glaptop>  <50355021.7000408@lwfinger.net> <1345694593.5904.87.camel@edumazet-glaptop>
In-Reply-To: <1345694593.5904.87.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 11:03 PM, Eric Dumazet wrote:
>
> Changing the allocation size removes the problem ? thats really strange.
>
> If you try different sizes in the 9100-30720 range, can you pinpoint the
> failure threshold ?

The allocation size change did not fix the problem. It turned out that 10 tries 
from a secure web page were not enough to trigger this intermittent problem that 
particular test.

Based on DaveM's comment that skb->truesize could be wrong, I tried setting 
truesize after every netdev_alloc_skb() call. Of course, that had no effect. I 
then found https://lkml.org/lkml/2010/11/19/505I, which clearly states why this 
need not be done.

What skb modifications require that truesize be adjusted? The driver never 
resets skb->len or skb->data_len for any buffers, other than setting skb->len to 
zero.

Thanks,

Larry

