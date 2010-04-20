Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0DTMcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:32:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab0DTMcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:32:23 -0400
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
From: Eric Paris <eparis@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BCD646B.1080206@cn.fujitsu.com>
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
	 <20100311032843.GE6767@linux.vnet.ibm.com>
	 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
	 <1271098032.4807.137.camel@twins> <1271242058.32749.19.camel@laptop>
	 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
	 <20100419230136.GA16856@linux.vnet.ibm.com>
	 <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
	 <20100420030452.GB2905@linux.vnet.ibm.com>
	 <4BCD646B.1080206@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 08:31:56 -0400
Message-ID: <1271766716.2972.16.camel@dhcp231-113.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 16:23 +0800, Lai Jiangshan wrote:

> [PATCH] RCU: don't turn off lockdep when find suspicious rcu_dereference_check() usage
> 
> When suspicious rcu_dereference_check() usage is detected, lockdep is still
> available actually, so we should not call debug_locks_off() in
> lockdep_rcu_dereference().
> 
> For get rid of too much "suspicious rcu_dereference_check() usage"
> output when the "if(!debug_locks_off())" statement is removed. This patch uses
> static variable '__warned's for very usage of "rcu_dereference*()".
> 
> One variable per usage, so, Now, we can get multiple complaint
> when we detect multiple different suspicious rcu_dereference_check() usage.
> 
> Requested-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Although mine was a linux-next kernel and it doesn't appear that I have
rcu_dereference_protected() at all, so I dropped that bit of the patch,
it worked great!  I got 4 more complaints to harass people with.  Feel
free to add my tested by if you care to.

Tested-by: Eric Paris <eparis@redhat.com>

