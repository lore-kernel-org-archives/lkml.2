Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0HQJcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:32:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57522 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab0HQJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:32:09 -0400
Message-ID: <4C6A580D.5010903@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 17:36:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 08/10] rcu: Add a TINY_PREEMPT_RCU
References: <20100809221447.GA24358@linux.vnet.ibm.com> <1281392111-25060-8-git-send-email-paulmck@linux.vnet.ibm.com> <20100816150737.GB8320@Krystal> <20100816183355.GH2388@linux.vnet.ibm.com> <20100816191947.GA970@Krystal> <20100816213200.GK2388@linux.vnet.ibm.com> <20100816214123.GA15663@Krystal> <20100816215555.GL2388@linux.vnet.ibm.com> <20100816220705.GA18650@Krystal> <20100816222402.GM2388@linux.vnet.ibm.com>
In-Reply-To: <20100816222402.GM2388@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 06:24 AM, Paul E. McKenney wrote:

>> --(t->rcu_read_lock_nesting)
>>
>> could be split in two distinct operations:
>>
>> read t->rcu_read_lock_nesting
>> decrement t->rcu_read_lock_nesting
>>
>> Note that in order to know the result required to pass the sequence
>> point "&&" (the test), we only need to perform the read, not the
>> decrement. AFAIU, gcc would be in its rights to move the
>> t->rcu_read_lock_nesting update after the volatile access.
> 
> I will run this by some compiler experts.
> 

We can just use "read and decrement statements" instead of "--" to
avoid dependency from compilers.
