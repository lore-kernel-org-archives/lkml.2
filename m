Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2DIWqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:46:10 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49362 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2DIWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:46:08 -0400
From: Paul Moore <paul@paul-moore.com>
To: Will Drewry <wad@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: ANN: libseccomp
Date: Mon, 09 Apr 2012 18:46:02 -0400
Message-ID: <5076094.qra9nCCzS0@sifl>
User-Agent: KMail/4.8.2 (Linux/3.3.1-gentoo; KDE/4.8.2; x86_64; ; )
In-Reply-To: <CABqD9haXLBDxEkC3+3AN4d4PDVYE-JrqH4P6iTJ95mqYxoR=yA@mail.gmail.com>
References: <1540670.AFBi1SpGoi@sifl> <1580647.pAHyaBF6MS@sifl> <CABqD9haXLBDxEkC3+3AN4d4PDVYE-JrqH4P6iTJ95mqYxoR=yA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 09, 2012 04:51:30 PM Will Drewry wrote:
> On Mon, Apr 9, 2012 at 4:32 PM, Paul Moore <paul@paul-moore.com> wrote:
> > On Monday, April 09, 2012 12:16:30 PM Kees Cook wrote:
> >> On Mon, Apr 9, 2012 at 11:58 AM, Paul Moore <paul@paul-moore.com> wrote:
> >> > With the seccomp patches finally stabilizing a bit, it seems like now
> >> > is a
> >> > good time to announce libseccomp: a library designed to make it easier
> >> > to
> >> > create complex, architecture independent seccomp filters.
> >> > 
> >> >  * http://sourceforge.net/projects/libseccomp/
> >> >  * git clone git://git.code.sf.net/p/libseccomp/libseccomp
> >> 
> >> This looks really great; nice work!
> 
> Agreed -- this is great to see!

Not as much as the actual kernel support :)

> >> I see that the arch check happens during _gen_bpf_build_bpf(), which
> >> is excellent. Do you have any thoughts about including a call to
> >> prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) by default as well?
> > 
> > That is a good question, and I guess it comes down to another question of
> > if anyone would want to use seccomp without NO_NEW_PRIVS.  If the answer
> > is no then I'm comfortable adding it into the seccomp_load() function;
> > however, if the answer is yes we might want to do something different.
> > 
> > I haven't given much thought to this yet, so if you or anyone else feels
> > strongly about the issue - either pro or con - I'd appreciate hearing the
> > argument.
> 
> I guess the question is if there is an expectation that this library
> be used with something like lxc, where a whole, functional system with
> suid/fcaps binaries is contained.  In that world, it may not be
> desirable to set the nnp bit.   The same is true if, for some reason,
> the init task was to set a system-wide filter.
> 
> Most likely, default use of nnp is probably "the right thing", but
> it'd be nice to be able to annotate when you really want to allow
> privileged contexts to set filters without nnp.

Okay, that seems reasonable: default to NO_NEW_PRIVS, but provide an override 
mechanism.

I've been wanting a mechanism/API for tweaking some of the default library 
parameters for the past few weeks, this is likely the last bit of motivation I 
need to start working on this.  I'll look into it once the license issue is 
sorted.

-- 
paul moore
www.paul-moore.com

