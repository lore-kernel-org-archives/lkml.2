Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab2HWMty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:49:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61380 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2HWMtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:49:50 -0400
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Bergmann <alex@linlab.net>
Cc: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <50362407.9070805@linlab.net>
References: <503419D3.1080700@linlab.net>
	 <CAFbMe2M7ekc94bQk7vTS1LhScPd49VZ-zKOCUXhqwxXtL-nkuA@mail.gmail.com>
	 <50361AEA.6010807@linlab.net> <1345724123.5904.756.camel@edumazet-glaptop>
	 <50362407.9070805@linlab.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Aug 2012 14:49:45 +0200
Message-ID: <1345726185.5904.835.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 14:37 +0200, Alex Bergmann wrote:

> 
> From be551f82499112e4775b6d579d58967510b6d492 Mon Sep 17 00:00:00 2001
> From: Alexander Bergmann <alex@linlab.net>
> Date: Thu, 23 Aug 2012 14:33:35 +0200
> Subject: [PATCH 1/1] tcp: Increase timeout for SYN segments
> 
> Commit 9ad7c049 changed the initRTO from 3secs to 1sec in accordance to
> RFC6298 (former RFC2988bis). This reduced the time till the last SYN
> retransmission packet gets sent from 93secs to 31secs.
> 
> RFC1122 is stating that the retransmission should be done for at least 3
> minutes, but this seems to be quite high.[1]
> 
> This patch increases the value of TCP_SYN_RETRIES to the value of 6,
> providing a retransmission window of 63secs.
> 
> [1] RFC 1122 - 4.2.3.5 TCP Connection Failures
> 
> Signed-off-by: Alexander Bergmann <alex@linlab.net>
> ---
>  include/net/tcp.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 1f000ff..f309e93 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -98,7 +98,7 @@ extern void tcp_time_wait(struct sock *sk, int state, int timeo);
>                                  * 15 is ~13-30min depending on RTO.
>                                  */
>  
> -#define TCP_SYN_RETRIES         5      /* number of times to retry active opening a
> +#define TCP_SYN_RETRIES         6      /* number of times to retry active opening a
>                                  * connection: ~180sec is RFC minimum   */
>  
>  #define TCP_SYNACK_RETRIES 5   /* number of times to retry passive opening a

Acked-by: Eric Dumazet <edumazet@google.com>

A change of the comment might be good, to help future readers.



