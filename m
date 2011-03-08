Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1CHSZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:25:48 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:46733 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753401Ab1CHSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:25:45 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ISgpaNAVM1lYVqK5iuEaM.8xKVxV8CLBUmdaMS5aG3Q74AX
 JLvyEzKgPS_9QEW19t_JARcAuTlV401ClAhazyez8_f5EHr_TzQ.lDcEnndT
 hFYYzOy6e2JTn1GMdNSYA3TmWYau8lIzSFHPY8pTW74u9LkTqGifrIr8IhkH
 LpqzmanoM429jjaf.dHIYvvukXT7NPSf6bXQHyjKL1q_0Qp5XP3Tio085bCj
 KigEuAe22HzqCDKXB24nBXxB4VNYilBHuD67e_Wl39Q--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 8 Mar 2011 12:25:41 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
In-Reply-To: <4D6CA852.3060303@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1103081224550.25214@router.home>
References: <4D6CA852.3060303@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Lai Jiangshan wrote:

> -		 * RCU free overloads the RCU head over the LRU
> -		 */
> -		struct rcu_head *head = (void *)&page->lru;
> +		struct rcu_head *head;
> +
> +		if (need_reserve_slab_rcu) {
> +			int order = compound_order(page);
> +			int offset = (PAGE_SIZE << order) - s->reserved;
> +
> +			BUG_ON(s->reserved != sizeof(*head));

VM_BUG_ON is sufficient here I think.

Otherwise

Acked-by: Christoph Lameter <cl@linux.com>

