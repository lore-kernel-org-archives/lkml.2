Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab1CBCys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 21:54:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab1CBCyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 21:54:47 -0500
Message-ID: <4D6DB1BD.60003@cn.fujitsu.com>
Date: Wed, 02 Mar 2011 10:55:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
References: <4D6CA852.3060303@cn.fujitsu.com> <AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com> <alpine.DEB.2.00.1103010909320.6253@router.home>
In-Reply-To: <alpine.DEB.2.00.1103010909320.6253@router.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 10:53:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 10:53:38,
	Serialize complete at 2011-03-02 10:53:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 11:11 PM, Christoph Lameter wrote:
> On Tue, 1 Mar 2011, Pekka Enberg wrote:
> 
>> The SLAB and SLUB patches are fine by me if there are going to be real
>> users for this. Christoph, Paul?
> 
> The solution is a bit overkill. It would be much simpler to add a union to
> struct page that has lru and the rcu in there similar things can be done
> for SLAB and the network layer. A similar issue already exists for the
> spinlock in struct page. Lets follow the existing way of handling this.

I don't want to impact the whole system too much to
touch struct page. The solution changes existed things little,
and the reversed data may just make use of the pad data.

> 
> Struct page may be larger for debugging purposes already because of the
> need for extended spinlock data.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

