Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2JJTB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:01:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62518 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab2JJTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:01:55 -0400
Subject: Re: [PATCH net-next?] pktgen: Use simpler test for non-zero ipv6
 address
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1349894559.2035.12.camel@joe-AO722>
References: <1349894559.2035.12.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Oct 2012 21:01:50 +0200
Message-ID: <1349895710.21172.7235.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 11:42 -0700, Joe Perches wrote:
> Reduces object size and should be slightly faster.
> 
> allyesconfig:
> 
> $ size net/core/pktgen.o*
>    text	   data	    bss	    dec	    hex	filename
>   52251	   4293	  11824	  68368	  10b10	net/core/pktgen.o.new
>   52310	   4293	  11848	  68451	  10b63	net/core/pktgen.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Found by looking for if (foo) ; tests with a perl regex
> 
> Yes Eric, it could be 2 compares instead of 4 on 64-bit
> systems with HAS_EFFICIENT_UNALIGNED_ACCESS.  Maybe later
> or if there are other tests that could become something
> like ipv6_is_zeronet.
> 
> cheers, Joe
> 
>  net/core/pktgen.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index 148e73d..3aa8417 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -2422,11 +2422,10 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
>  		}
>  	} else {		/* IPV6 * */
>  
> -		if (pkt_dev->min_in6_daddr.s6_addr32[0] == 0 &&
> -		    pkt_dev->min_in6_daddr.s6_addr32[1] == 0 &&
> -		    pkt_dev->min_in6_daddr.s6_addr32[2] == 0 &&
> -		    pkt_dev->min_in6_daddr.s6_addr32[3] == 0) ;
> -		else {
> +		if (pkt_dev->min_in6_daddr.s6_addr32[0] |
> +		    pkt_dev->min_in6_daddr.s6_addr32[1] |
> +		    pkt_dev->min_in6_daddr.s6_addr32[2] |
> +		    pkt_dev->min_in6_daddr.s6_addr32[3]) {
>  			int i;
>  
>  			/* Only random destinations yet */
> 



What about ipv6_addr_any() ?

anyway net-next is not opened yet


