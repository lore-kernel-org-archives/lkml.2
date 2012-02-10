Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab2BJT15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:27:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027Ab2BJT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:27:56 -0500
Date: Fri, 10 Feb 2012 17:27:14 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
Message-ID: <20120210192714.GE4998@infradead.org>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com> <1328895795.25989.29.camel@laptop> <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 10, 2012 at 10:59:51AM -0800, Linus Torvalds escreveu:
> On Fri, Feb 10, 2012 at 9:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > So I CC'ed Linus who has a strong here, jejb since he's the one that
> > told me several time there's a number of literate dwarfs already in the
> > kernel and Jan because I think it was him that tried last on x86.
> 
> I never *ever* want to see this code ever again.
> 
> Sorry, but last time was too f*cking painful. The whole (and *only*)
> point of unwinders is to make debugging easy when a bug occurs. But
> the f*cking dwarf unwinder had bugs itself, or our dwarf information
> had bugs, and in either case it actually turned several "trivial" bugs
> into a total undebuggable hell.
> 
> It was made doubly painful by the developers involved then several
> times ignoring the problem, and claiming the code was bug-free when it
> clearly wasn't, or trying to claim that the problem was that we set up
> some random dwarf information wrong, when THAT GOES WITHOUT SAYING
> (since dwarf is a complex mess that never gets any actual testing
> except when things go wrong - at which point the code had better work
> regardless of whether the dwarf info was correct or not).
> 
> So no. An unwinder that is several hundred lines long is simply not
> even *remotely* interesting to me.
> 
> If you can mathematically prove that the unwinder is correct - even in
> the presence of bogus and actively incorrect unwinding information -
> and never ever follows a bad pointer, I'll reconsider.
> 
> In the absence of that, just follow the damn chain on the stack
> *without* the "smarts" of an inevitably buggy piece of crap.

"Vote for --fno-omit-frame-pointer! One register is a cheap price to pay
for not going insane!"

/me goes back to non political things.

- Arnaldo
