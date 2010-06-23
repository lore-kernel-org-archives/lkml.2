Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0FWV3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:29:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44041 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0FWV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:29:48 -0400
Date: Wed, 23 Jun 2010 14:28:31 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-ID: <20100623212831.GA4809@outflux.net>
References: <20100623181129.GM5876@outflux.net>
 <20100623194145.GA19628@redhat.com>
 <20100623202335.GA4424@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623202335.GA4424@x200>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 11:23:35PM +0300, Alexey Dobriyan wrote:
> On Wed, Jun 23, 2010 at 09:41:45PM +0200, Oleg Nesterov wrote:
> > On 06/23, Kees Cook wrote:
>  
> > > -extern char *get_task_comm(char *to, struct task_struct *tsk);
> > > +#define get_task_comm(buf, task) get_task_comm_size(buf, sizeof(buf), task)
> > > +extern char *get_task_comm_size(char *to, size_t len, struct task_struct *tsk);
> > 
> > Oh, but this means that get_task_comm(ptr, task) doesn't work?
> 
> The number of users is so small, and everyone uses TASK_COMM_LEN,
> so maybe nothing should be done or "char buf[TASK_COMM_LEN]"?

I couldn't handle the pathological use of strncpy(dest, src, sizeof(src))
that is currently in get_task_comm; that's just asking for trouble.

If someone wants to use a ptr for get_task_comm, they would get to call
get_task_comm_size() instead?

-Kees

-- 
Kees Cook
Ubuntu Security Team
