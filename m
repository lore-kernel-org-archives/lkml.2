Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab2HVQaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:30:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44434 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2HVQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:30:08 -0400
Date: Wed, 22 Aug 2012 13:29:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Luigi Semenzato <semenzato@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] perf: do not flush maps on COMM for perf report
Message-ID: <20120822162958.GA13623@infradead.org>
References: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
 <20120822072822.GA11042@gmail.com>
 <CAA25o9RJOre2mw4z7Mh94iRKcHVdby9RjLfP91far16me8_94Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA25o9RJOre2mw4z7Mh94iRKcHVdby9RjLfP91far16me8_94Q@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 22, 2012 at 09:09:10AM -0700, Luigi Semenzato escreveu:
> On Wed, Aug 22, 2012 at 12:28 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > * Luigi Semenzato <semenzato@chromium.org> wrote:
> >> An alternative patch (which I proposed earlier) would be to
> >> introduce a separate PERF_RECORD_EXEC type, but it is a much
> >> larger change (about 300 lines) and is not necessary.

> > It would be nice to add that too - we already have FORK/EXIT,
> > this seems like a natural extension.

> Yes.  Adding PERF_RECORD_EXEC is/would be the right long-term
> solution.  But there are two issues.

> 1. One nice aspect of perf is that perf.data files and "perf report"
> are compatible across a large number of versions.  Adding
> PERF_RECORD_EXEC breaks compatibility in a somewhat unpleasant manner.
>  New perf.data files won't work with old versions of perf and *might*
> fail poorly (segv) although this situation is difficult to analyze.

> 2. Adding a new record type is messy.  It replicates a lot of
> boilerplate code, much of it in the kernel, and affects many parts of
> the system.  It adds to size, complexity, and likelihood of new bugs.

> I would prioritize the "would be nice" category as follows.

> 1. Improve the handling of unknown record types for future better
> backward compatibility.  (Small change.)

> 2. Refactor/cleanup code to improve readability and robustness.  (Big
> change, but can be broken into many smaller pieces.)

> 3. Add PERF_RECORD_EXEC.

> If there is consensus, I might be able to give a shot to 1 and 2
> (courtesy of Google).

I think this is just common sense, i.e. I'd love to take patches that
improve the robustness of the tools any day.

Refactoring code to make it cleaner and possibly faster and/or smaller,
ditto.

Adding the EXEC event, ditto. And I agree that while adding it we want
to do 1/2 as pre-requisite.

- Arnaldo
