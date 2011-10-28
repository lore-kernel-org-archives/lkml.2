Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1J1HYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:24:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40151 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1J1HX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:23:59 -0400
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Sasha Levin <levinsasha928@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <20111028070336.GF12995@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
	 <20111027193448.GA3514@merkur.ravnborg.org>
	 <20111028070336.GF12995@elte.hu>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 28 Oct 2011 09:23:55 +0200
Message-ID: <1319786635.3235.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 09:03 +0200, Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Thu, Oct 27, 2011 at 02:07:14PM +0200, Sasha Levin wrote:
> > > This patch adds 'make kvmconfig' which allows to add KVM guest support
> > > to a config file.
> > > 
> > > This allows for easier testing of configurations under virtualized
> > > environments.
> > > 
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: Michal Marek <mmarek@suse.cz>
> > > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > > Cc: linux-kbuild@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Suggested-by: Ingo Molnar <mingo@elte.hu>
> > > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > 
> > Two points about the implmentation that I do not like...
> > 
> > The kvmconfig is an x86 specific thing - so it does not belong
> > in the scripts/kconfig/Makefile
> > 
> > The *config namespace is general config targets.
> > 
> > Suggestion:
> > Move the implmentation to arch/x86/Makefile and name the target
> > something that does not match the *config pattern.
> > 
> > Suggestion:
> > 
> >    make kvmbootable
> > 
> > To tell that this convert the current config to a kvmbootable config.
> > 
> > And then add the target to the x86 specific help too.
> 
> KVM itself is not x86 specific (although this patch obviously is), so 
> we'd like to keep at least the naming non-x86.
> 
> Furthermore, the functionality generally fits into the pattern that 
> 'oldconfig' does: it changes an existing config - so having 'config' 
> in the name somewhere makes quite a bit of sense. If i didn't know 
> what 'kvmbootable' does i couldnt guess that it touches the .config - 
> while the *config pattern makes that patently obvious.
> 
> Could we set aside some sort of name for such subsystem specific 
> purposes and be done with it? Could we reuse the 'defconfig' 
> naming perhaps and make it richer:
> 
> 	make defconfig kvm
> 
> or:
> 
> 	make defconfig-kvm
> 
> ? It would be very obvious at a glance what it does.

We can possibly make 'make defconfig abc' run arch specific script
located next to the defconfig files (arch/$(ARCH)/configs/).

It would both solve the problem with being arch specific, and would
allow for future expansion of other 'kvm defconfig' options.

-- 

Sasha.

