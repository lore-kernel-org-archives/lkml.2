Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2LTMdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:33:19 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40001 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2LTMdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:33:12 -0500
X-Greylist: delayed 1533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 07:33:12 EST
Message-ID: <50D2FF86.3000603@6wind.com>
Date: Thu, 20 Dec 2012 13:07:34 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stefan Hasko <hasko.stevo@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: route: fixed a coding style issues net: ipv4:
 tcp: fixed a coding style issues
References: <1355990910-3688-1-git-send-email-hasko.stevo@gmail.com>
In-Reply-To: <1355990910-3688-1-git-send-email-hasko.stevo@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/12/2012 09:08, Stefan Hasko a écrit :
> Fix a coding style issues.
>
> Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
> ---
>   net/ipv4/route.c |  125 ++++++++++++++++++-------------
>   net/ipv4/tcp.c   |  218 +++++++++++++++++++++++++++++++-----------------------
>   2 files changed, 200 insertions(+), 143 deletions(-)
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 844a9ef..fff7ce6 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -20,7 +20,7 @@
>    *		Alan Cox	:	Added BSD route gw semantics
>    *		Alan Cox	:	Super /proc >4K
>    *		Alan Cox	:	MTU in route table
> - *		Alan Cox	: 	MSS actually. Also added the window
> + *		Alan Cox	:	MSS actually. Also added the window
>    *					clamper.
>    *		Sam Lantinga	:	Fixed route matching in rt_del()
>    *		Alan Cox	:	Routing cache support.
> @@ -31,30 +31,35 @@
>    *	Miquel van Smoorenburg	:	BSD API fixes.
>    *	Miquel van Smoorenburg	:	Metrics.
>    *		Alan Cox	:	Use __u32 properly
> - *		Alan Cox	:	Aligned routing errors more closely with BSD
> + *		Alan Cox	:	Aligned routing errors more
> + *					closely with BSD
>    *					our system is still very different.
>    *		Alan Cox	:	Faster /proc handling
> - *	Alexey Kuznetsov	:	Massive rework to support tree based routing,
> + *	Alexey Kuznetsov	:	Massive rework to support
> + *					tree based routing,
>    *					routing caches and better behaviour.
>    *
>    *		Olaf Erb	:	irtt wasn't being copied right.
>    *		Bjorn Ekwall	:	Kerneld route support.
>    *		Alan Cox	:	Multicast fixed (I hope)
> - * 		Pavel Krauz	:	Limited broadcast fixed
> + *		Pavel Krauz	:	Limited broadcast fixed
>    *		Mike McLagan	:	Routing by source
>    *	Alexey Kuznetsov	:	End of old history. Split to fib.c and
>    *					route.c and rewritten from scratch.
>    *		Andi Kleen	:	Load-limit warning messages.
> - *	Vitaly E. Lavrov	:	Transparent proxy revived after year coma.
> + *	Vitaly E. Lavrov	:	Transparent proxy revived
> + *					after year coma.
>    *	Vitaly E. Lavrov	:	Race condition in ip_route_input_slow.
> - *	Tobias Ringstrom	:	Uninitialized res.type in ip_route_output_slow.
> + *	Tobias Ringstrom	:	Uninitialized res.type in
> + *					ip_route_output_slow.
>    *	Vladimir V. Ivanov	:	IP rule info (flowid) is really useful.
>    *		Marc Boucher	:	routing by fwmark
>    *	Robert Olsson		:	Added rt_cache statistics
>    *	Arnaldo C. Melo		:	Convert proc stuff to seq_file
> - *	Eric Dumazet		:	hashed spinlocks and rt_check_expire() fixes.
> - * 	Ilia Sotnikov		:	Ignore TOS on PMTUD and Redirect
> - * 	Ilia Sotnikov		:	Removed TOS from hash calculations
> + *	Eric Dumazet		:	hashed spinlocks and
> + *					rt_check_expire() fixes.
> + *	Ilia Sotnikov		:	Ignore TOS on PMTUD and Redirect
> + *	Ilia Sotnikov		:	Removed TOS from hash calculations
>    *
>    *		This program is free software; you can redistribute it and/or
>    *		modify it under the terms of the GNU General Public License
> @@ -65,7 +70,7 @@
>   #define pr_fmt(fmt) "IPv4: " fmt
>
>   #include <linux/module.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>   #include <linux/bitops.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
> @@ -139,7 +144,8 @@ static unsigned int	 ipv4_default_advmss(const struct dst_entry *dst);
>   static unsigned int	 ipv4_mtu(const struct dst_entry *dst);
>   static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst);
>   static void		 ipv4_link_failure(struct sk_buff *skb);
> -static void		 ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
> +static void		 ip_rt_update_pmtu(struct dst_entry *dst,
> +					   struct sock *sk,
>   					   struct sk_buff *skb, u32 mtu);
>   static void		 ip_do_redirect(struct dst_entry *dst, struct sock *sk,
>   					struct sk_buff *skb);
> @@ -291,12 +297,17 @@ static int rt_cpu_seq_show(struct seq_file *seq, void *v)
>   	struct rt_cache_stat *st = v;
>
>   	if (v == SEQ_START_TOKEN) {
> -		seq_printf(seq, "entries  in_hit in_slow_tot in_slow_mc in_no_route in_brd in_martian_dst in_martian_src  out_hit out_slow_tot out_slow_mc  gc_total gc_ignored gc_goal_miss gc_dst_overflow in_hlist_search out_hlist_search\n");
> +		seq_printf(seq, "entries  in_hit in_slow_tot in_slow_mc "
> +				"in_no_route in_brd in_martian_dst "
> +				"in_martian_src  out_hit out_slow_tot "
> +				"out_slow_mc  gc_total gc_ignored "
> +				"gc_goal_miss gc_dst_overflow in_hlist_search "
> +				"out_hlist_search\n");
checkpatch will warn you about this one, something like:
"WARNING: quoted string split across lines".
Not breaking such line ease to grep the pattern.

Nicolas
