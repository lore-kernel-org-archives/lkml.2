Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2ARJ3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:29:02 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41125 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757193Ab2ARJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:29:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19RMXUg4nNRXU3mcbAphUeVGMYDFK+OPdeFntxLGn
	RNY2ZNtSJuYmy9
Subject: Re: [PATCH RT 2/4] wait-simple: Simple waitqueue implementation
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <20120118034700.245278561@goodmis.org>
References: <20120118034531.335521323@goodmis.org>
	 <20120118034700.245278561@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 10:28:48 +0100
Message-ID: <1326878928.7482.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

On Tue, 2012-01-17 at 22:45 -0500, Steven Rostedt wrote:

> diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
> new file mode 100644
> index 0000000..7f1cb72
> --- /dev/null
> +++ b/kernel/wait-simple.c
> @@ -0,0 +1,62 @@
> +/*
> + * Simple waitqueues without fancy flags and callbacks
> + *
> + * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
> + *
> + * Based on kernel/wait.c
> + *
> + * For licencing details see kernel-base/COPYING
> + */
> +#include <linux/init.h>
> +#include <linux/sched.h>
> +#include <linux/wait-simple.h>
> +
> +void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
> +{
> +	raw_spin_lock_init(&head->lock);
> +	lockdep_set_class(&head->lock, key);
> +	INIT_LIST_HEAD(&head->list);
> +}
> +EXPORT_SYMBOL_GPL(__init_swait_head);

#include <linux/module.h> ?

	-Mike

