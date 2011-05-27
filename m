Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1E0QLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:11:25 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:65457 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1E0QLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:11:24 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
	 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 12:11:13 -0400
Message-ID: <1306512673.3339.12.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 08:42 -0700, Linus Torvalds wrote:
> On Thu, May 26, 2011 at 3:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Well, as far as I can tell, this feature is going to break hibernation on
> > both x86_32 and x86_64 at the moment, unless you can guarantee that the
> > randomized kernel location will be the same for both the boot and the target
> > kernels.
> 
> You know what? Maybe that guarantee is actually the *right* thing to do..
> 
> In other words, maybe we really really shouldn't randomize the kernel
> load address at boot time at all.
> 
> Instead, what would be much better, is if we just had some way to
> re-link distro kernels with some random text offset. Sure, the load
> address wouldn't be "random" in any local sense any more, but I think
> the real effort here was to avoid having the common distro kernels
> having known text addresses.
> 
> If you compile your own kernel version, you're already home free, and
> load-time randomization is pointless.
> 
> And load-time randomization has all these nasty problems with memory
> maps etc, because we obviously have to shift the whole kernel around
> by some fixed offset. But if there was some way to just re-link the
> distro kernel easily, then it could be done by the kernel install
> scripts, and it could potentially do more than just "shift up load
> address by some random number".
> 
> Hmm?
> 
>                           Linus

You know what...I'm surprised that I'm saying this, but given the number
of non-trivial challenges that still need to be solved in order to
implement load-time randomization, maybe this would be a better way
forward.

We'd still need to go through the same effort to hide information about
kernel text offsets, and we'd still need to do per-cpu IDTs, but neither
of those items are as challenging as some of the other problems.

I'm not ready to take load-time randomization off the table, but I'd
certainly like to hear more discussion on this.  There are clearly
advantages to load-time randomization that this new option wouldn't
have, but the question is really "is what we gain worth the effort?".

Thanks,
Dan

