Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab1D1KLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:11:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab1D1KLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:11:19 -0400
Date: Thu, 28 Apr 2011 13:11:17 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: export rcu_note_context_switch() function
Message-ID: <20110428101117.GP2265@redhat.com>
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
 <1303984323-3203-2-git-send-email-gleb@redhat.com>
 <4DB93AE0.4050303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB93AE0.4050303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 01:01:04PM +0300, Avi Kivity wrote:
> On 04/28/2011 12:52 PM, Gleb Natapov wrote:
> >Signed-off-by: Gleb Natapov<gleb@redhat.com>
> >@@ -93,11 +93,7 @@ static inline int rcu_needs_cpu(int cpu)
> >
> >  #endif /* #else #ifdef CONFIG_TINY_RCU */
> >
> >-static inline void rcu_note_context_switch(int cpu)
> >-{
> >-	rcu_sched_qs(cpu);
> >-	rcu_preempt_note_context_switch();
> >-}
> >+extern void rcu_note_context_switch(int cpu);
> >
> 
> Why are you uninlining this function?  Why not export the two
> functions it calls instead?
> 
To keep exported interface uniformal between both rcu implementations.
I do not think that rcu_note_context_switch() is inlined for
performance reason since two functions it calls are quite big in rcutiny
implementation. Paul what do you think?
 
--
			Gleb.
