Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1AaLuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:50:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:48119 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab1AaLup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:50:45 -0500
Subject: Re: [RFC -v7 PATCH 5/7] export pid symbols needed for
 kvm_vcpu_on_spin
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110126172303.3d5184a7@annuminas.surriel.com>
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>
	 <20110126172303.3d5184a7@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 Jan 2011 12:51:39 +0100
Message-ID: <1296474699.15234.396.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:23 -0500, Rik van Riel wrote:
> Export the symbols required for a race-free kvm_vcpu_on_spin.

Avi, you asked for an example of why I hated KVM as a module :-)

> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3b159c5..adc8f47 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -191,6 +191,7 @@ void __put_task_struct(struct task_struct *tsk)
>  	if (!profile_handoff_task(tsk))
>  		free_task(tsk);
>  }
> +EXPORT_SYMBOL_GPL(__put_task_struct);
>  
>  /*
>   * macro override instead of weak attribute alias, to workaround
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 39b65b6..02f2212 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -435,6 +435,7 @@ struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
>  	rcu_read_unlock();
>  	return pid;
>  }
> +EXPORT_SYMBOL_GPL(get_task_pid);
>  
>  struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
>  {
> @@ -446,6 +447,7 @@ struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
>  	rcu_read_unlock();
>  	return result;
>  }
> +EXPORT_SYMBOL_GPL(get_pid_task);
>  
>  struct pid *find_get_pid(pid_t nr)
>  {


