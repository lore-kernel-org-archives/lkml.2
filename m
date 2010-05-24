Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0EXOho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab0EXOhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:37:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100522165401.GB19573@redhat.com>
References: <20100522165401.GB19573@redhat.com> <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage of child->mm
Date: Mon, 24 May 2010 15:36:57 +0100
Message-ID: <25539.1274711817@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Now that Mike Frysinger unified the FDPIC ptrace code, we can fix
> the unsafe usage of child->mm in ptrace_request(PTRACE_GETFDPIC).
> 
> We have the reference to task_struct, and ptrace_check_attach()
> verified the tracee is stopped. But nothing can protect from
> SIGKILL after that, we must not assume child->mm != NULL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>

Does it make sense to move the call to get_task_mm() up to sys_ptrace() since
several ptrace functions use it?  The mm pointer could then be handed down the
ptrace hierarchy.

David
