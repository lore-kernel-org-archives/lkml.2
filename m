Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2HVQAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:00:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64464 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2HVQAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:00:18 -0400
Message-ID: <5035020E.5040806@lwfinger.net>
Date: Wed, 22 Aug 2012 11:00:14 -0500
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
References: <50345B12.1050600@lwfinger.net> <1345612503.5158.566.camel@edumazet-glaptop>
In-Reply-To: <1345612503.5158.566.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 12:15 AM, Eric Dumazet wrote:
>
> This particular commit is the start of a patches batch that ended in the
> generic TCP coalescing mechanism.
>
> It is known to have problem on drivers doing skb_clone() in their rx
> path.
>
> Current kernels should be ok, because coalescing doesnt happen if the
> destination skb is cloned (skb_cloned(to) in skb_try_coalesce())
>
> For 3.4 kernel, I guess I need to backport this skb_cloned(to) check fo
> stable 3.4 kernel
>
> But these skb_clone() in various USB drivers should be killed for good,
> they really can kill the box because of skb->truesize lies.

Applying your patch to 3.4 does not fix the problem. In addition, all of the 
problems I noted happen with 3.6-rc2 - current kernels are not OK.

Of the drivers I reported, only r8712u in staging/rtl8712/rtl8712_recv.c has a 
direct call to skb_clone(). As its symptoms are different, the cloning is likely 
the source of the problems there. In addition, the problem is intermittent. The 
driver normally allocates a new buffer and copies to it, and the clone only 
occurs when that skb allocation fails. I will try to fix that. My skb skills are 
minimal and I will have to do some studying.

Thanks,

Larry


