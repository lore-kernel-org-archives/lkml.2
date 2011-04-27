Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab1D0Q6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:58:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44991 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab1D0Q6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l1puIwV9rRj4vkEETHub8teItToxAUw5jx/EsbZ0G0KS5gpLga821KEtJ+hmPKk5PM
         F1Zkql+on/C0OUzfTfAA0FNBHS5X/oH5wDlIp5uRYlTAsS5MaVLA7c4Vf3EtPnsyLFv+
         2bVPqC2rcn0Jcdvd4cXsYdLuP2QMTM7fgadeY=
MIME-Version: 1.0
In-Reply-To: <4DB7957C.2070307@cn.fujitsu.com>
References: <4DB52ED5.6070800@cn.fujitsu.com>
	<20110425134855.GH2681@linux.vnet.ibm.com>
	<4DB7957C.2070307@cn.fujitsu.com>
Date: Thu, 28 Apr 2011 00:58:46 +0800
Message-ID: <BANLkTikQxDeHzvs6yw9SiE8M9VN0qNgRcw@mail.gmail.com>
Subject: Re: [PATCH] rcu: fix possible bug in include/linux/pagemap.h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>, paulmck@linux.vnet.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 12:03 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> On 04/25/2011 09:48 PM, Paul E. McKenney wrote:
>> On Mon, Apr 25, 2011 at 04:20:37PM +0800, Lai Jiangshan wrote:
>>> I read the code and comments written by Nick Piggin(mainly from e286781d),
>>> page_cache_get_speculative() is protected by rcu_read_lock(),
>>> it may be preempted when preemptible RCU, so we must use get_page_unless_zero()
>>> in this situation.
>>>
>>> In the days of e286781d, we only have CLASSIC_RCU and (old)PREEMPT_RCU,
>>> so "defined(CONFIG_CLASSIC_RCU)" means non-preemptible RCU and the code is correct.
>>>
>>> In the days of b560d8ad, we only have TREE_RCU and TREE_PREEMPT_RCU,
>>> so "defined(CONFIG_TREE_RCU)" means non-preemptible RCU and the code is correct.
>>>
>>> But in nowadays, we have TREE_RCU, TREE_PREEMPT_RCU, TINY_RCU and TINY_PREEMPT_RCU,
>>> so the "defined(CONFIG_TREE_RCU)" for non-preemptible RCU is incorrect, and it may causes bugs.
>>> we should use "!defined(CONFIG_PREEMPT_RCU)" for non-preemptible RCU code block.
>>>
>>> CC: Nick Piggin <npiggin@kernel.dk>
>>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> Reported-by: WANG Cong <amwang@redhat.com>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> Good catch!!!
>>
>> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
>
>
> Sorry, I forgot to CC it to LKML. Added it.
>

Thanks for fixing this!

The description explains quite well, so I am okay with this patch,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

BTW, you added my company email in Reported-by, but Cc'ed my gmail. ;-)
