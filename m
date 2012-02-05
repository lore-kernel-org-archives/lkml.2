Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2BETic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 14:38:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab2BETib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 14:38:31 -0500
Date: Sun, 5 Feb 2012 20:31:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>, stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 2/2 v4] preempt-rt/x86: Delay calling signals in int3
Message-ID: <20120205193146.GC12183@redhat.com>
References: <20120203182853.547078531@goodmis.org> <20120203183041.427463295@goodmis.org> <20120203184016.GA10413@redhat.com> <1328299833.5882.211.camel@gandalf.stny.rr.com> <20120205192305.GB12183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120205192305.GB12183@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn. Sorry for noise...

On 02/05, Oleg Nesterov wrote:
>
> +int force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
> +{
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +	if (in_atomic()) {
> +		if (WARN_ON_ONCE(t != current))

This is certainly wrong in upstream kernel. It does use force_
this way although it shouldn't imho.

But _probably_ this is fine for rt? We are going to take the mutex,
we shouldn't do this in atomic context. But, once again, I do not
really know what in_atomic() means in rt.

Oleg.

