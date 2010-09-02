Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0IBRFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:05:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44948
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596Ab0IBRFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:05:35 -0400
Date: Thu, 02 Sep 2010 10:05:51 -0700 (PDT)
Message-Id: <20100902.100551.115929058.davem@davemloft.net>
To: peterz@infradead.org
Cc: lizf@cn.fujitsu.com, herbert@gondor.hengli.com.au, davej@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] cls_cgroup: Fix rcu lockdep warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283423916.2059.1847.camel@laptop>
References: <4C7F446F.8040303@cn.fujitsu.com>
	<1283423916.2059.1847.camel@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 02 Sep 2010 12:38:36 +0200

> On Thu, 2010-09-02 at 14:30 +0800, Li Zefan wrote:
>> Calling task_subsys_state() without holding rcu_read_lock or
>> cgroup_mutex can cause lockdep warning.
>> 
> 
> That is not a suitable changelog.
> 
> Was the warning correct? Is your patch correct? What does RCU protect
> here and why can we use classid after dropping it.
> 
> Simply frobbing code to make the warning go away is not good.

In fact shouldn't this be a rcu_dereference() or similar?
