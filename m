Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1CAPLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:11:39 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:27722 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756566Ab1CAPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:11:38 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: y9nAQ9oVM1nLyTooo8lXnqIA_JXSmcmMja4KuNJggGzKW00
 sX2JROpOHSouAHhbQsECrz8O1DPL3SvNhjMQAfT3Wsg5llqK_tEnsm0yKOvL
 sd7e86YYGpkS0MP0NasglDCdFwJh6JzZtPrKFu1QY91CHkTtGBRlAcZFX3fB
 9tHmSKDabIYMkRMNOQ0ChUD.4pXP9iCUnEomoav96s8rtpSXj1VGCzYo_TaR
 pTafdpuHmDAf6E8rTtW4seWwwl1P.Q6cqFzly
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 1 Mar 2011 09:11:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
In-Reply-To: <AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103010909320.6253@router.home>
References: <4D6CA852.3060303@cn.fujitsu.com> <AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Pekka Enberg wrote:

> The SLAB and SLUB patches are fine by me if there are going to be real
> users for this. Christoph, Paul?

The solution is a bit overkill. It would be much simpler to add a union to
struct page that has lru and the rcu in there similar things can be done
for SLAB and the network layer. A similar issue already exists for the
spinlock in struct page. Lets follow the existing way of handling this.

Struct page may be larger for debugging purposes already because of the
need for extended spinlock data.
