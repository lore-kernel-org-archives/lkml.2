Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1D0EHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 00:07:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1D0EH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 00:07:27 -0400
Message-ID: <4DB7957C.2070307@cn.fujitsu.com>
Date: Wed, 27 Apr 2011 12:03:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        stable@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: fix possible bug  in include/linux/pagemap.h
References: <4DB52ED5.6070800@cn.fujitsu.com> <20110425134855.GH2681@linux.vnet.ibm.com>
In-Reply-To: <20110425134855.GH2681@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-27 12:00:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-27 12:07:49,
	Serialize complete at 2011-04-27 12:07:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2011 09:48 PM, Paul E. McKenney wrote:
> On Mon, Apr 25, 2011 at 04:20:37PM +0800, Lai Jiangshan wrote:
>> I read the code and comments written by Nick Piggin(mainly from e286781d),
>> page_cache_get_speculative() is protected by rcu_read_lock(),
>> it may be preempted when preemptible RCU, so we must use get_page_unless_zero()
>> in this situation.
>>
>> In the days of e286781d, we only have CLASSIC_RCU and (old)PREEMPT_RCU,
>> so "defined(CONFIG_CLASSIC_RCU)" means non-preemptible RCU and the code is correct.
>>
>> In the days of b560d8ad, we only have TREE_RCU and TREE_PREEMPT_RCU,
>> so "defined(CONFIG_TREE_RCU)" means non-preemptible RCU and the code is correct.
>>
>> But in nowadays, we have TREE_RCU, TREE_PREEMPT_RCU, TINY_RCU and TINY_PREEMPT_RCU,
>> so the "defined(CONFIG_TREE_RCU)" for non-preemptible RCU is incorrect, and it may causes bugs.
>> we should use "!defined(CONFIG_PREEMPT_RCU)" for non-preemptible RCU code block.
>>
>> CC: Nick Piggin <npiggin@kernel.dk>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Reported-by: WANG Cong <amwang@redhat.com>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Good catch!!!
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 


Sorry, I forgot to CC it to LKML. Added it.


Hi, Nick Piggin,

Could you review it?

Thanks,
Lai
