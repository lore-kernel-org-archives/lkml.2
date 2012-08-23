Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab2HWV0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:26:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58275 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab2HWV0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:26:47 -0400
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <50369925.3050705@lwfinger.net>
References: <50345B12.1050600@lwfinger.net>
	 <1345612503.5158.566.camel@edumazet-glaptop>
	 <50355021.7000408@lwfinger.net> <1345694593.5904.87.camel@edumazet-glaptop>
	 <50369925.3050705@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Aug 2012 23:26:40 +0200
Message-ID: <1345757200.5904.1890.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 15:57 -0500, Larry Finger wrote:
> On 08/22/2012 11:03 PM, Eric Dumazet wrote:
> >
> > Changing the allocation size removes the problem ? thats really strange.
> >
> > If you try different sizes in the 9100-30720 range, can you pinpoint the
> > failure threshold ?
> 
> The allocation size change did not fix the problem. It turned out that 10 tries 
> from a secure web page were not enough to trigger this intermittent problem that 
> particular test.
> 
> Based on DaveM's comment that skb->truesize could be wrong, I tried setting 
> truesize after every netdev_alloc_skb() call. Of course, that had no effect. I 
> then found https://lkml.org/lkml/2010/11/19/505I, which clearly states why this 
> need not be done.
> 
> What skb modifications require that truesize be adjusted? The driver never 
> resets skb->len or skb->data_len for any buffers, other than setting skb->len to 
> zero.

skb->truesize is adjusted when a frag is added to one skb, or when
skb->head is re-allocated.

Are you sure you dont have another problem, because as I said commit
c8628155ece3  had a bug, so a bisect is not very useful.

How many reloads are needed to trigger the bug, do you have a script to
reproduce it ?

Could it be a PMTU problem ? (check
http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=9b04f350057863d1fad1ba071e09362a1da3503e )


