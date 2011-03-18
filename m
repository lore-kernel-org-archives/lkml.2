Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1CRIOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:14:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1CRIOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:14:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH V5 1/1] rcu: introduce kfree_rcu()
Date: Fri, 18 Mar 2011 09:14:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
References: <4D7F356C.8020903@cn.fujitsu.com> <20110316040203.GB2273@linux.vnet.ibm.com> <4D82CE63.4030006@cn.fujitsu.com>
In-Reply-To: <4D82CE63.4030006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103180914.31464.arnd@arndb.de>
X-Provags-ID: V02:K0:+/b26Bw5RhMz1boWZt0XH00WOKwJChGTybt/Di3EL3o
 ZyoOE7TcYvHMiYcCmVwJ8n4nqtIsSgWRpCY3LNzQZj3mEHALJR
 P6CEZMge9y82pz+Jn/GNosaqqLG6SB5UVvesvEVzO+pGjuUOb7
 DM9JLrFvvV5IPqb8dy7lHQBzn5oy16tqFuFPVNDB8Zb0W7/adJ
 vPSpEcEFUUsfst27EYuvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Lai Jiangshan wrote:
> kfree_rcu() which was original proposed by Lai 2.5 years ago is one of
> the most important RCU TODO list entries, Lai and Manfred have worked on
> patches for this. This V4 patch is based on the Manfred's patch and
> the V1 of Lai's patch. (These two patches are almost the same
> in implementation, and this patch is mainly based on the Manfred's).
> 
> Lai's V1 patch: http://lkml.org/lkml/2008/9/18/1
> Manfred's patch: http://lkml.org/lkml/2009/1/2/115
> RCU TODO list: http://www.kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
> 
> This new introduced API kfree_rcu() primitive kfree()s the specified memory
> after a RCU grace period elapses.
> 
> It replaces many simple "call_rcu(head, simple_kfree_callback)";
> These many simple_kfree_callback() instances just does
> 
>         kfree(containerof(head,struct whatever_struct,rcu_member));
> 
> These simple_kfree_callback() instances are just duplicate code, we need
> a generic function for them.
> 
> And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
> queue any function which belong to the module, so a rcu_barrier() can
> be avoid when module exit. (If we queue any other function by call_rcu(),
> rcu_barrier() is still needed.)
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
