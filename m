Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2EaGlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab2EaGlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:41:45 -0400
Message-ID: <4FC71306.50806@redhat.com>
Date: Thu, 31 May 2012 14:43:18 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: sock: validate data_len before allocating skb in
 sock_alloc_send_pskb()
References: <20120530054702.6146.8503.stgit@amd-6168-8-1.englab.nay.redhat.com>  <1338360383.2760.84.camel@edumazet-glaptop>  <20120530.030205.1337682162603770949.davem@davemloft.net>  <4FC708EE.2020908@redhat.com> <20120531060201.GA13158@redhat.com>  <4FC70BA8.5060200@redhat.com> <1338445232.2760.1171.camel@edumazet-glaptop>
In-Reply-To: <1338445232.2760.1171.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 02:20 PM, Eric Dumazet wrote:
> On Thu, 2012-05-31 at 14:11 +0800, Jason Wang wrote:
>
>> Not affected, only code duplication. It's no harm the check the data_len
>> again for packet sockets, so better to unify the code and fix the issue
>> in one place?
> As a matter of fact, we currently allocate order-0 pages, but it could
> be nice trying to use order-1 or order-2 pages, on arches where
> PAGE_SIZE is so small (4096 bytes)
>
> So lets do this test in sock_alloc_send_pskb() to allow future changes.
>
> af_unix is kind of special, because it tries to lower risk of high order
> linear allocation failures. And for small sizes, it wants linear skbs to
> have no performance regression (prior kernels were allocating linear
> skbs)
>

Thanks for the clarification, would post V2.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

