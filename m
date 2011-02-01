Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1BAPwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:52:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1BAPwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:52:53 -0500
Subject: Re: [PATCH -v8a 3/7] sched: use a buddy to implement
 yield_task_fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110201095103.3a79e92a@annuminas.surriel.com>
References: <20110201094433.72829892@annuminas.surriel.com>
	 <20110201095103.3a79e92a@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Feb 2011 16:53:44 +0100
Message-ID: <1296575624.26581.212.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 09:51 -0500, Rik van Riel wrote:
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -375,13 +375,6 @@ static struct ctl_table kern_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = sched_rt_handler,
>         },
> -       {
> -               .procname       = "sched_compat_yield",
> -               .data           = &sysctl_sched_compat_yield,
> -               .maxlen         = sizeof(unsigned int),
> -               .mode           = 0644,
> -               .proc_handler   = proc_dointvec,
> -       },
>  #ifdef CONFIG_PROVE_LOCKING
>         {
>                 .procname       = "prove_locking",
> 
There's another instance of sysctl_sched_compat_yield in sched.h, I'll
remove that and its definition in sched_fair.c too ;-)
