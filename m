Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab1BORc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:32:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab1BORcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:32:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
In-Reply-To: Tejun Heo's message of  Tuesday, 15 February 2011 16:24:48 +0100 <20110215152448.GL3160@htj.dyndns.org>
References: <20110207174821.GA1237@redhat.com>
	<20110209141803.GH3770@htj.dyndns.org>
	<201102132325.55353.vda.linux@googlemail.com>
	<20110214151340.GP18742@htj.dyndns.org>
	<AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
	<20110214175144.GC15847@redhat.com>
	<AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
	<20110214190141.GA19221@redhat.com>
	<AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com>
	<20110214200130.GA21559@redhat.com>
	<20110215152448.GL3160@htj.dyndns.org>
Emacs: you'll understand when you're older, dear.
Message-Id: <20110215173149.239601807B7@magilla.sf.frob.com>
Date: Tue, 15 Feb 2011 09:31:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually I was thinking along this line.  We can allow
> PTRACE_GETSIGINFO to proceed without forcing the tracee into TRACED
> state, the rationale being the operation is required to tell between
> group stop and ptrace trap.  Am I missing something?

The reason for the transition to TASK_TRACED is to prevent a race with
SIGCONT waking the task.  There is always a race with SIGKILL waking it,
but the circumstances where that can really matter are far fewer.
You need to make sure that the work PTRACE_GETSIGINFO does to access
last_siginfo cannot race with that pointer disappearing or the stack
space it points to becoming invalid.  I think the use of siglock ensures
that, but Oleg should verify it.


Thanks,
Roland
