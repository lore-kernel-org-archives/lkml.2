Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0LWLDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:03:06 -0500
Received: from payne.is.scarlet.be ([193.74.71.226]:37092 "EHLO
	payne.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0LWLDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:03:05 -0500
Message-ID: <4D132C5F.8090404@scarlet.be>
Date: Thu, 23 Dec 2010 11:02:55 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Jarek Poplawski <jarkao2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Help: major pppoe regression since 2.6.35 (panic on first ppp
 conection)?
References: <20101222110021.GA8985@ff.dom.local>	 <4D122093.6060900@scarlet.be> <1293035100.3027.247.camel@edumazet-laptop>
In-Reply-To: <1293035100.3027.247.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,


On 12/22/2010 04:25 PM, Eric Dumazet wrote:
[snip]
>
> Something overwrites nr_frags in skb_shinfo(skb)
>
> As skb_shinfo follows head portion of an skb, something overflows skb
> head
>
> Please try adding some room like in following patch ?
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index e6ba898..adf2834 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -187,6 +187,7 @@ enum {
>    * the end of the header data, ie. at skb->end.
>    */
>   struct skb_shared_info {
> +	char		filler[64];
>   	unsigned short	nr_frags;
>   	unsigned short	gso_size;
>   	/* Warning: this field is not always filled in (UFO)! */
>
Sorry for delay but I have good news, I am sending this answer from:
$ uname -a
Linux sidh2 2.6.37-rc7-amd64-t1 #1 SMP Thu Dec 23 10:30:27 GMT 2010 x86_64 GNU/Linux

with your tips ;<) (without kernel had already died)

That said how can find stuff overflowing skb head? (all I say, is that this issue started with 2.6.34-git6???)

Thanks a lot,
	J.
