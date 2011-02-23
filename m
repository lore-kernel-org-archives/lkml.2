Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1BWRLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:11:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab1BWRLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:11:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110217150333.GE26395@mail.hallyn.com>
References: <20110217150333.GE26395@mail.hallyn.com> <20110217150224.GA26334@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: dhowells@redhat.com, LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
Subject: Re: [PATCH 5/9] Allow ptrace from non-init user namespaces
Date: Wed, 23 Feb 2011 17:11:01 +0000
Message-ID: <3016.1298481061@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serge@hallyn.com> wrote:

> +int same_or_ancestor_user_ns(struct task_struct *task,
> +	struct task_struct *victim)
> +{
> +	struct user_namespace *u1 = task_cred_xxx(task, user)->user_ns;
> +	struct user_namespace *u2 = task_cred_xxx(victim, user)->user_ns;

Hmmm.  task_cred_xxx() uses task->real_cred, which is correct for victim (the
object), but normally you'd use task->cred for task (the subject).  However,
in this case, I think it's probably okay.

David
