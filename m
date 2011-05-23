Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1EWNgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:36:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab1EWNgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:36:04 -0400
Date: Mon, 23 May 2011 15:34:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
	ptracer
Message-ID: <20110523133426.GC7232@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <20110519165722.GP627@htj.dyndns.org> <20110519171327.GA19698@redhat.com> <201105200048.07942.vda.linux@googlemail.com> <20110520085921.GB31426@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520085921.GB31426@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Tejun Heo wrote:
>
> 1. A process has two threads t1 and t2.  t1 is ptraced by p1.  Both t1
>    and t2 are running.
>
> 2. p1 INTERRUPTs t1.  t1 enters TRAP_STOP and p1 notices it.
>
> 3. Something else sends SIGSTOP to t2 which initiates group stop.
>
> 4. As t1 re-traps to notify p1 of group stop, p1 issues PTRACE_CONT.
>
> 5. PTRACE_CONT succeeds right after t1 re-traps for notification and
>    t1 resumes execution.

IOW. The root of the problem is that TASK_TRACED no longer means the
tracee is stopped, it can change its state and the "volatile" info
in si_pt_flags reflects this fact.

This makes me nervous ;) Yes, we hide the TRACED->RUNNING->TRACED
transitions, and I have to agree that the proposed API looks consistent
to me. Still, can't we do this differently ? (see another email).

Oleg.

