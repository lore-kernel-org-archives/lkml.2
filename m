Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab0GUWZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0GUWZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:25:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        Oleg Nesterov <oleg@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
 doesn't ptrace other processes
In-Reply-To: Andrew Morton's message of  Wednesday, 21 July 2010 14:49:44 -0700 <20100721144944.5351c741.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
	<20100721144944.5351c741.akpm@linux-foundation.org>
Emacs: because extension languages should come with the editor built in.
Message-Id: <20100721222529.EFBAA400B6@magilla.sf.frob.com>
Date: Wed, 21 Jul 2010 15:25:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -331,6 +331,9 @@ void exit_ptrace(struct task_struct *tra
> >  	struct task_struct *p, *n;
> >  	LIST_HEAD(ptrace_dead);
> >  
> > +	if (list_empty(&tracer->ptraced))
> > +		return;
> > +
> >  	write_lock_irq(&tasklist_lock);
> >  	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
> >  		if (__ptrace_detach(tracer, p))

I think we may have tried that before.  Oleg can tell us if it's really
safe vs a race with PTRACE_TRACEME or something like that.


Thanks,
Roland
