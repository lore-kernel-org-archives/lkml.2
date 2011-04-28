Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab1D1KBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1D1KBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:01:09 -0400
Message-ID: <4DB93AE0.4050303@redhat.com>
Date: Thu, 28 Apr 2011 13:01:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
References: <1303984323-3203-1-git-send-email-gleb@redhat.com> <1303984323-3203-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1303984323-3203-2-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 12:52 PM, Gleb Natapov wrote:
> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> @@ -93,11 +93,7 @@ static inline int rcu_needs_cpu(int cpu)
>
>   #endif /* #else #ifdef CONFIG_TINY_RCU */
>
> -static inline void rcu_note_context_switch(int cpu)
> -{
> -	rcu_sched_qs(cpu);
> -	rcu_preempt_note_context_switch();
> -}
> +extern void rcu_note_context_switch(int cpu);
>

Why are you uninlining this function?  Why not export the two functions 
it calls instead?

-- 
error compiling committee.c: too many arguments to function

