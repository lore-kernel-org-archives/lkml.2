Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965817Ab2EPUQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:16:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:64663 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965598Ab2EPUQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:16:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167267067"
Message-ID: <4FB40B2B.703@linux.intel.com>
Date: Wed, 16 May 2012 13:16:43 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
References: <1337175871.6724.46.camel@gandalf.stny.rr.com> <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com> <1337198404.6724.81.camel@gandalf.stny.rr.com> <CA+55aFyKiNBRv=z8JjPTu=yFFvyWHhkGDxjWLm=R4HpwXzEw4g@mail.gmail.com> <4FB408F2.8060002@linux.intel.com> <20120516201431.GA29661@redhat.com>
In-Reply-To: <20120516201431.GA29661@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/2012 1:14 PM, Dave Jones wrote:
> On Wed, May 16, 2012 at 01:07:14PM -0700, Arjan van de Ven wrote:
>  > On 5/16/2012 1:04 PM, Linus Torvalds wrote:
>  > > On Wed, May 16, 2012 at 1:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>  > >>
>  > >> Seriously though. What's your take on changing the kernel that will
>  > >> break an older distro. Obviously, this change is too early to apply. But
>  > >> because an old distro has one app that will break if we make a change in
>  > >> the kernel, is that enough to keep that change out?
>  > > 
>  > > I suspect that powertop is enough of a developer thing that if that's
>  > > the only thing that breaks, we don't have to worry too much.
>  > > 
>  > > I don't want to break *everybody*, so new distro's should be
>  > > up-to-date. But breaking something like a F14-15 timeframe distro or
>  > > something staid like a SLES (or "Debian Stale" or whatever they call
>  > > that thing that only takes crazy-old binaries)? It's fine. We don't
>  > > want to *rush* into it, but no, if those distros are basically not
>  > > updating, we can't care about them forever for something like
>  > > powertop.
>  > 
>  > agreed.
>  > 
>  > I would say something like "6 months" (e.g. 3.6); anybody who's likely
>  > to update anything will have done the powertop upgrade from his distro
>  > by then, and anybody who isn't isn't going to update the kernel either.
> 
> One possibility would be a config symbol to enable the deprecated field
> (kind of like what we did with compat vdso).  Distros that have a new
> enough powertop can then disable it.

this isn't really about distro kernels; a distro that pushes a 3.7
kernel to Fedora 15 might as well do a powertop upgrade.. the later is
much simpler and lighter (the main difference between 1.98 and 2.0 is
the use of the perfevent library anyway)

it's about people who compile their own upstream kernel...
