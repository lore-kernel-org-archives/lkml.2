Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1KGOlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:41:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35368 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1KGOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:41:17 -0500
Message-ID: <1320676871.2361.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, shaohua.li@intel.com, ak@linux.intel.com,
        mhocko@suse.cz, alex.shi@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>
Date: Mon, 07 Nov 2011 15:41:11 +0100
In-Reply-To: <CABPqkBTbxBbRqvS-+L2ex3ZTPT+Xy-T_eqf3iTCpq+-tnOpbnw@mail.gmail.com>
References: <20111003161335.GA2403@linux.vnet.ibm.com>
	 <20111004074637.GA14061@elte.hu>
	 <20111024100501.GA24913@linux.vnet.ibm.com>
	 <20111024114806.GA3340@linux.vnet.ibm.com> <20111026203020.GA10285@elte.hu>
	 <20111027075901.GB2313@linux.vnet.ibm.com> <20111027080016.GA16885@elte.hu>
	 <4EAA14A1.5060204@cn.fujitsu.com>
	 <20111029182710.GG6160@linux.vnet.ibm.com>
	 <4EAE57AF.1060706@cn.fujitsu.com>
	 <20111031093256.GI6160@linux.vnet.ibm.com>
	 <4EAF5B68.8090005@cn.fujitsu.com>
	 <CABPqkBS-fio57xePQ76LLxPxVMJRM1cKzU1DgXH7q9oNG54N8Q@mail.gmail.com>
	 <4EB3A5DA.3080305@cn.fujitsu.com>
	 <CABPqkBR=dB3E1ba-cR7L5A2uknidBJTMdMBNFzyr+zsmjuxacw@mail.gmail.com>
	 <CABPqkBTbxBbRqvS-+L2ex3ZTPT+Xy-T_eqf3iTCpq+-tnOpbnw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 07 novembre 2011 à 14:24 +0000, Stephane Eranian a écrit :
> Hi,
> 
> Some second thoughts on this.
> 
> We get the warning because:
> 
> #define task_subsys_state_check(task, subsys_id, __c)                   \
>         rcu_dereference_check(task->cgroups->subsys[subsys_id],         \
>                               lockdep_is_held(&task->alloc_lock) ||     \
>                               cgroup_lock_is_held() || (__c))
> 
> 
> In other words, we need the alloc_lock held.
> 
> What I don't quite understand in your patch in the connection
> between rcu and this particular task lock. Unless holding
> the rcu read lock implies you necessarily hold the alloc_lock.
> 
> Can you explain?

#define rcu_dereference_check(p, c) \
	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)

So if you hold rcu_read_lock(), (c) is not checked/asserted.



