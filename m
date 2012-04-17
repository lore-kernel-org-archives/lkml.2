Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2DQOXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:23:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab2DQOXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:23:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120414021252.GC23393@redhat.com>
References: <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] cred: change keyctl_session_to_parent() to use task_work_add()
Date: Tue, 17 Apr 2012 15:23:00 +0100
Message-ID: <27037.1334672580@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> -	int ret;
> +	struct cred *cred;
> +	int err;

There's no need to change ret to be err.  It produces slightly less churn if
you don't.

> +	err = -ENOMEM;
> +	newwork = kmalloc(sizeof(struct task_work), GFP_KERNEL);
> +	if (!newwork)
> +		goto error_keyring;

This passes unnecessarily through kfree(newwork).  Please add a new goto label
and go to that.

> -/*
> - * Replace a process's session keyring on behalf of one of its children when
> - * the target  process is about to resume userspace execution.
> - */

Please don't delete the banner comment saying what the function does.

> -void key_replace_session_keyring(void)
> +void key_change_session_keyring(struct task_work *twork)

There's no particular need to change the name of the function.

David
