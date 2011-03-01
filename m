Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1CAIQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:16:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56800
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab1CAIQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:16:01 -0500
Date: Tue, 01 Mar 2011 00:16:38 -0800 (PST)
Message-Id: <20110301.001638.104075130.davem@davemloft.net>
To: laijs@cn.fujitsu.com
Cc: mingo@elte.hu, paulmck@linux.vnet.ibm.com, cl@linux-foundation.org,
        penberg@kernel.org, eric.dumazet@gmail.com, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net,rcu: don't assume the size of struct rcu_head
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D6CA860.3020409@cn.fujitsu.com>
References: <4D6CA860.3020409@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 01 Mar 2011 16:03:44 +0800

> 
> struct dst_entry assumes the size of struct rcu_head as 2 * sizeof(long)
> and manually adds pads for aligning for "__refcnt".
> 
> When the size of struct rcu_head is changed, these manual padding
> is wrong. Use __attribute__((aligned (64))) instead.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

We don't want to use the align if it's going to waste lots of space.

Instead we want to rearrange the structure so that the alignment comes
more cheaply.
