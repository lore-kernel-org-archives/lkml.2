Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1BNPPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:15:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab1BNPPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:15:37 -0500
Date: Mon, 14 Feb 2011 16:06:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110214150656.GA8761@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <20110204130455.GA3671@redhat.com> <20110204144858.GI12133@htj.dyndns.org> <201102132224.25197.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102132224.25197.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13, Denys Vlasenko wrote:
>
> For example, PTRACE_DETACH requires tracee to be stopped to succeed.
> If debugger tries to detach while the tracee is running, it will get
> an error. This forces debugger to do stupid things like sending SIGSTOP,
> then waiting for tracee to stop, then doing PTRACE_DETACH, then
> sending SIGCONT. Of course, while this dance is performed,
> any SIGSTOPs/SIGCONTs which may be  sent to the tracee by other processes
> are totally disrupted by this.

Yes.

> The natural (for me) fix is to make PTRACE_DETACH work even on running
> tracee. It simply makes a lot of sense. Why on earth do we need tracee
> to be stopped? There is no reason.

Agreed, but

> But this is a change in ptrace behavior, and therefore is not acceptable
> for Roland.

I agree with Roland. Not only this is too visible change, it is not clear
what detach-with-signal can do if the tracee is not stopped.

This was (very briefly) discussed recently. Probably we can implement
PTRACE_DETACH_RUNNING (the name is random) which doesn't require the
stopped tracee but ignores the "data" argument.

Oleg.

