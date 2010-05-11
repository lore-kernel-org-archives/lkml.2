Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0EKHys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:54:48 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44964 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0EKHyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:54:46 -0400
Date: Tue, 11 May 2010 02:52:15 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@vnet.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] INIT_TASK() should initialize ->thread_group list
Message-ID: <20100511075215.GA18702@us.ibm.com>
References: <4BE01C86.3050908@secunet.com>
 <20100509184510.GA15219@redhat.com>
 <4BE7B3BD.70901@secunet.com>
 <20100510194917.GA5249@redhat.com>
 <20100510194949.GB5249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510194949.GB5249@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> The trivial /sbin/init doing
> 
> 	int main(void)
> 	{
> 		kill(0, SIGKILL)
> 	}
> 
> crashes the kernel.
> 
> This happens because __kill_pgrp_info(init_struct_pid) also sends SIGKILL
> to the swapper process which runs with the uninitialized ->thread_group.
> 
> Change INIT_TASK() to initialize ->thread_group properly.
> 
> Note: the real problem is that the swapper process must not be visible to
> signals, see the next patch. But this change is right anyway and fixes
> the crash.
> 
> Reported-and-tested-by: Mathias Krause <mathias.krause@secunet.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Serge E. Hallyn <serue@us.ibm.com>

> ---
> 
>  include/linux/init_task.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 34-rc1/include/linux/init_task.h~1_INIT_TASK_THREAD_GROUP	2010-05-10 19:44:19.000000000 +0200
> +++ 34-rc1/include/linux/init_task.h	2010-05-10 19:45:27.000000000 +0200
> @@ -172,6 +172,7 @@ extern struct cred init_cred;
>  		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
>  		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
>  	},								\
> +	.thread_group	= LIST_HEAD_INIT(tsk.thread_group),		\
>  	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
>  	INIT_IDS							\
>  	INIT_PERF_EVENTS(tsk)						\
