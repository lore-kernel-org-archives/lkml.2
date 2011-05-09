Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1EIRAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 13:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab1EIRAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 13:00:08 -0400
Date: Mon, 9 May 2011 18:58:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110509165857.GA30607@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> Currently, there's no way to trap a running ptracee short of sending a
> signal which has various side effects.  This patch implements
> PTRACE_INTERRUPT which traps ptracee without any signal or job control
> related side effect.
>
> The implementation is almost trivial.  It uses the same trap site and
> event as PTRACE_SEIZE.  A new trap flag JOBCTL_TRAP_INTERRUPT is
> added, which is set on PTRACE_INTERRUPT and cleared when tracee
> commits to INTERRUPT trap.  As INTERRUPT should be useable regardless
> of the current state of tracee, task_is_traced() test in
> ptrace_check_attach() is skipped for INTERRUPT.

Heh. As usual, I can never review the patches in time. Will continue
tomorrow.

Right now I am a bit puzzled why do we have 2 bits, JOBCTL_TRAP_INTERRUPT
and JOBCTL_TRAP_SEIZE... But I didn't read this + other patches yet.

At first glance, JOBCTL_TRAP_INTERRUPT has the same problem with the
killed tracee. I think this is easy to fix.

Oleg.

