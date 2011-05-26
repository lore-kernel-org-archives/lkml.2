Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab1EZSri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:47:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab1EZSrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:47:37 -0400
Date: Thu, 26 May 2011 20:47:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Drewry <wad@chromium.org>, Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526184723.GA3177@elte.hu>
References: <20110525191152.GC19633@outflux.net>
 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
 <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
 <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
 <BANLkTimZjwdepwS2mjysRyHytfhd2P7vSA@mail.gmail.com>
 <BANLkTi=UFB6PLfsSTVpFEQbveMs-W4MjUg@mail.gmail.com>
 <BANLkTim44ziUsEbYVOjfLPvOLfhUgH9itw@mail.gmail.com>
 <BANLkTineHBZ-oHRsfc9R6bpcp_oyczL5pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTineHBZ-oHRsfc9R6bpcp_oyczL5pA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> It also gets rid of all configuration - one of the things that 
> makes most security frameworks (look at selinux, but also just 
> ACL's etc) such a crazy rats nest is the whole "set up for other 
> processes". If it's designed very much to be about just the "self" 
> process (after initialization etc), then I think that avoids pretty 
> much all the serious issues.

That's how the event filters work currently: even when inherited they 
get removed when exec-ing a setuid task, so they cannot leak into 
privileged context and cannot modify execution there.

Inheritance works when requested, covering only same-credential child 
tasks, not privileged successors.

Thanks,

	Ingo
