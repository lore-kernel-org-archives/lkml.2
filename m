Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab1EZSyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:54:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758345Ab1EZSyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:54:39 -0400
Date: Thu, 26 May 2011 20:54:32 +0200
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
Message-ID: <20110526185432.GB3476@elte.hu>
References: <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <20110525191152.GC19633@outflux.net>
 <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
 <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com>
 <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com>
 <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com>
 <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
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

> And if you filter system calls, it's entirely possible that you can 
> attack suid executables through such a vector. Your "limit system 
> calls for security" security suddenly turned into "avoid the system 
> call that made things secure"!

That should not be possible with Will's event filter based solution 
(his last submitted patch), due to this code in fs/exec.c (which is 
in your upstream tree as well):

        /*
         * Flush performance counters when crossing a
         * security domain:
         */
        if (!get_dumpable(current->mm))
                perf_event_exit_task(current);

This will drop all filters if a setuid-root (or whatever setuid) 
binary is executed from a filtered environment.

Does this cover the case you were thinking of?

Thanks,

	Ingo
