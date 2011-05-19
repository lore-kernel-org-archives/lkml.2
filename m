Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934657Ab1ESUUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:20:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926Ab1ESUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:20:06 -0400
Date: Thu, 19 May 2011 16:16:13 -0400 (EDT)
Message-Id: <20110519.161613.660024399062254005.davem@davemloft.net>
To: tsunanet@gmail.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, hagen@jauu.net,
        eric.dumazet@gmail.com, alexander.zimmermann@comsys.rwth-aachen.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Lower the initial RTO to 1s as per draft RFC
 2988bis-02.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305787669-84634-1-git-send-email-tsunanet@gmail.com>
References: <20110519.014656.1735519603194773578.davem@davemloft.net>
	<1305787669-84634-1-git-send-email-tsunanet@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 19 May 2011 13:16:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Sigoure <tsunanet@gmail.com>
Date: Wed, 18 May 2011 23:47:49 -0700

> @@ -868,6 +868,11 @@ static void tcp_init_metrics(struct sock *sk)
>  {
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct dst_entry *dst = __sk_dst_get(sk);
> +	/* If we had to retransmit anything during the 3WHS, use
> +	 * the initial fallback RTO as per draft RFC 2988bis-02.
> +	 */
> +	int init_rto = inet_csk(sk)->icsk_retransmits ?
> +		TCP_TIMEOUT_INIT_FALLBACK : TCP_TIMEOUT_INIT;

Please do not put comments in the middle of a set of function
local variable declarations.

Also, as mentioned already, icsk_retransmits is not where SYN
retransmissions are counted.

It is stored in the TCP minisocket ->retrans field.
