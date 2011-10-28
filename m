Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1J1HIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:08:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49030 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1J1HIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:08:17 -0400
Date: Fri, 28 Oct 2011 09:03:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
Message-ID: <20111028070336.GF12995@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
 <20111027193448.GA3514@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111027193448.GA3514@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, Oct 27, 2011 at 02:07:14PM +0200, Sasha Levin wrote:
> > This patch adds 'make kvmconfig' which allows to add KVM guest support
> > to a config file.
> > 
> > This allows for easier testing of configurations under virtualized
> > environments.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: linux-kbuild@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Suggested-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> 
> Two points about the implmentation that I do not like...
> 
> The kvmconfig is an x86 specific thing - so it does not belong
> in the scripts/kconfig/Makefile
> 
> The *config namespace is general config targets.
> 
> Suggestion:
> Move the implmentation to arch/x86/Makefile and name the target
> something that does not match the *config pattern.
> 
> Suggestion:
> 
>    make kvmbootable
> 
> To tell that this convert the current config to a kvmbootable config.
> 
> And then add the target to the x86 specific help too.

KVM itself is not x86 specific (although this patch obviously is), so 
we'd like to keep at least the naming non-x86.

Furthermore, the functionality generally fits into the pattern that 
'oldconfig' does: it changes an existing config - so having 'config' 
in the name somewhere makes quite a bit of sense. If i didn't know 
what 'kvmbootable' does i couldnt guess that it touches the .config - 
while the *config pattern makes that patently obvious.

Could we set aside some sort of name for such subsystem specific 
purposes and be done with it? Could we reuse the 'defconfig' 
naming perhaps and make it richer:

	make defconfig kvm

or:

	make defconfig-kvm

? It would be very obvious at a glance what it does.

Thanks,

	Ingo
