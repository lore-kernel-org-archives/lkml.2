Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab2JIQ2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:28:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab2JIQ2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:28:46 -0400
Date: Tue, 9 Oct 2012 18:29:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] [RFC] pidns: don't zap processes several times
Message-ID: <20121009162925.GA6517@redhat.com>
References: <1349603358-1085282-1-git-send-email-avagin@openvz.org> <20121007190118.GA16068@redhat.com> <CANaxB-w+KkhzTQVie=9PE8LJtazqvh+JducTcDmXvH+ZA4oO0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-w+KkhzTQVie=9PE8LJtazqvh+JducTcDmXvH+ZA4oO0A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Andrey Wagin wrote:
>
> 2012/10/7 Oleg Nesterov <oleg@redhat.com>:
> >
> > Perhaps we should MAX_PID_NS_LEVEL instead?
>
> Yes, we can.
>
> Could I just define MAX_PID_NS_LEVEL in a code:
> #define MAX_PID_NS_LEVEL ((PAGE_SIZE - offsetof(struct pid, numbers))
> / sizeof(struct upid))

Or even less. But looks reasonable.

> Or should it be added in a config?

Personally I think that "define" is fine, we can add config/sysctl
later if needed.


Hmm. This is off-topic, but...

	create_pid_namespace:

		unsigned int level = parent_pid_ns->level + 1;
		ns->pid_cachep = create_pid_cachep(level + 1);

is it correct? is seems that only one "+ 1" is needed?

Oleg.

