Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1E0RwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:52:04 -0400
Received: from outmail016.snc4.facebook.com ([66.220.144.148]:63303 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080Ab1E0RwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:52:00 -0400
Message-ID: <4DDFE4D6.4010000@fb.com>
Date: Fri, 27 May 2011 10:52:22 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        Yann Dupont <Yann.Dupont@univ-nantes.fr>,
        Denys Fedoryshchenko <denys@visp.net.lb>
Subject: Re: Kernel crash after using new Intel NIC (igb)
References: <201104250033.03401.maxi@daemonizer.de>	 <1303878240.2699.41.camel@edumazet-laptop>	 <1303878771.2699.44.camel@edumazet-laptop>	 <201104271352.00601.maxi@daemonizer.de>	 <20110512211033.GA3468@dev1756.snc6.facebook.com>	 <1305234953.2831.2.camel@edumazet-laptop>	 <20110524213327.GA3917@dev1756.snc6.facebook.com>	 <1306291469.3305.11.camel@edumazet-laptop>	 <20110525060609.GA32244@dev1756.snc6.facebook.com>	 <1306305331.3305.22.camel@edumazet-laptop>  <4DDEAA3C.7020502@fb.com>	 <1306439246.2543.10.camel@edumazet-laptop>  <4DDECA9B.8080206@fb.com>	 <1306447292.2543.32.camel@edumazet-laptop>  <4DDEEBC5.80804@fb.com> <1306466831.2543.58.camel@edumazet-laptop>
In-Reply-To: <1306466831.2543.58.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/11 8:27 PM, Eric Dumazet wrote:

Looks good. Thanks for taking care of this.

> +static bool atomic_add_unless_return(atomic_t *ptr, int a, int u, int *newv)
> +{
> +	int cur, old = atomic_read(ptr);
> +
> +	while (old != u) {
> +		*newv = old + a;
> +		cur = atomic_cmpxchg(ptr, old, *newv);
> +		if (cur == old)
> +			return true;
> +		old = cur;
> +	}
> +	return false;
> +}

This looks very similar to atomic_add_unless(). If we had a

__atomic_add_unless() that returned "old", we could then do:

atomic_add_unless() { return __atomic_add_unless() != u }
atomic_add_unless_return() { return __atomic_add_unless() + a}

  -Arun


