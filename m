Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3AHMYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:24:15 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37388 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab3AHMYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:24:14 -0500
Date: Tue, 8 Jan 2013 17:53:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes: Kill the bogus IS_ERR_VALUE(xol_vaddr)
 check
Message-ID: <20130108122347.GJ1325@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121231175150.GA32066@redhat.com>
 <20121231175232.GA32118@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121231175232.GA32118@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010812-7182-0000-0000-00000441754B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-12-31 18:52:32]:

> utask->xol_vaddr is either zero or valid, remove the bogus
> IS_ERR_VALUE() check in xol_free_insn_slot().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index ad1245d..ed4fcbe 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1223,8 +1223,7 @@ static void xol_free_insn_slot(struct task_struct *tsk)
>  		return;
> 
>  	slot_addr = tsk->utask->xol_vaddr;
> -
> -	if (unlikely(!slot_addr || IS_ERR_VALUE(slot_addr)))
> +	if (unlikely(!slot_addr))
>  		return;
> 
>  	area = tsk->mm->uprobes_state.xol_area;
> -- 
> 1.5.5.1
> 

