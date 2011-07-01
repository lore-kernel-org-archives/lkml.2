Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1GAQLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:11:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab1GAQLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:11:03 -0400
Date: Fri, 1 Jul 2011 18:10:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Drewry <wad@chromium.org>
Cc: James Morris <jmorris@namei.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110701161027.GA29035@elte.hu>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
 <1308875813-20122-5-git-send-email-wad@chromium.org>
 <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
 <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
 <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
 <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
 <20110701115600.GK20990@elte.hu>
 <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
 <20110701130705.GG12605@elte.hu>
 <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
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


* Will Drewry <wad@chromium.org> wrote:

> From my view, ftrace events are not ready for the job yet - and 
> relying purely on available wrapped events may make it unsuitable 
> for attack surface reduction forever.  As is, there is no compat 
> syscall support.  Many syscalls are not wrapped at present and no 
> one ack'd my earlier patches around wrapping more.  All of perf 
> needs to be overhauled to share per-task infrastructure. A new ABI 
> needs to be proposed if my prctl() changes are not acceptable to 
> handle some of the security-focused behavioral requirements.  
> Performance characteristics need to be better analyzed as the 
> current perf list_head approach may not scale as desired.  The list 
> goes on.  My proof of concept patch for "event filters" was just 
> that - a proof of concept.  To truly share the filter events is a 
> large amount of work that may not be viable, and I believe you know 
> that as well as I do.

But that's exactly my point: i consider it the right way forward 
because it maximizes kernel utility in the long run.

Note that *all* the specific technical items you mention:

 - wrapping more syscalls (i.e. making syscall tracing
   feature-complete)

 - a clean filtering ABI

 - performance improvements. (Note that this one is already
   in progress, Thomas has written an IDR implementation that
   eliminates the list iteration entirely. You could help him
   finish  it.)

are not some bad side effect or quirk, they are all generic 
improvements we want in any case and not just for sandboxing.

You might not be interested in all of those items, you are only 
interested in getting the narrow feature-set you are interested in, 
but you sure are interested in getting sandboxing versus not getting 
anything at all, right?

Not doing it right because "it's too much work", especially as the 
trivial 'proof of concept' prototype already gave us something very 
promising that worked to a fair degree:

       bitmask (2009):  6 files changed,  194 insertions(+), 22 deletions(-)
 filter engine (2010): 18 files changed, 1100 insertions(+), 21 deletions(-)
 event filters (2011):  5 files changed,   82 insertions(+), 16 deletions(-)

are pretty hollow arguments to me. That diffstat sums up my argument 
of proper structure pretty well.

Thanks,

	Ingo
