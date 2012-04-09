Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2DIW4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:56:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab2DIW4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:56:31 -0400
Date: Mon, 9 Apr 2012 17:56:25 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Will Drewry <wad@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org,
        libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [libseccomp-discuss] ANN: libseccomp
Message-ID: <20120409225625.GA24861@sergelap>
References: <1540670.AFBi1SpGoi@sifl>
 <CAGXu5jL5nAY4=5OKhA6VPdrzkUjVuBTcLQuMxUSEv_=N=ohbzQ@mail.gmail.com>
 <1580647.pAHyaBF6MS@sifl>
 <CABqD9haXLBDxEkC3+3AN4d4PDVYE-JrqH4P6iTJ95mqYxoR=yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABqD9haXLBDxEkC3+3AN4d4PDVYE-JrqH4P6iTJ95mqYxoR=yA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Will Drewry (wad@chromium.org):
> On Mon, Apr 9, 2012 at 4:32 PM, Paul Moore <paul@paul-moore.com> wrote:
> > On Monday, April 09, 2012 12:16:30 PM Kees Cook wrote:
> >> On Mon, Apr 9, 2012 at 11:58 AM, Paul Moore <paul@paul-moore.com> wrote:
> >> > With the seccomp patches finally stabilizing a bit, it seems like now is a
> >> > good time to announce libseccomp: a library designed to make it easier to
> >> > create complex, architecture independent seccomp filters.
> >> >
> >> >  * http://sourceforge.net/projects/libseccomp/
> >> >  * git clone git://git.code.sf.net/p/libseccomp/libseccomp
> >>
> >> This looks really great; nice work!
> 
> Agreed -- this is great to see!
> 
> >> I see that the arch check happens during _gen_bpf_build_bpf(), which
> >> is excellent. Do you have any thoughts about including a call to
> >> prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) by default as well?
> >
> > That is a good question, and I guess it comes down to another question of if
> > anyone would want to use seccomp without NO_NEW_PRIVS.  If the answer is no
> > then I'm comfortable adding it into the seccomp_load() function; however, if
> > the answer is yes we might want to do something different.
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

Right, check out Eric's posting of v24 of userns yesterday.  lxc will
be fine with no new privileges in the parent user ns, but in its
child user ns it will definately want to be free to do what it likes
with userids and capabilities.

-serge
