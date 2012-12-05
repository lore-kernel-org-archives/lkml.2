Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2LEHwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 02:52:55 -0500
Received: from ozlabs.org ([203.10.76.45]:59192 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2LEHwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 02:52:54 -0500
Message-ID: <1354693989.27132.3.camel@concordia>
Subject: Re: ccache: FATAL: Could not create /scratch/kisskb/ccache
From: Michael Ellerman <michael@ellerman.id.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Wed, 05 Dec 2012 18:53:09 +1100
In-Reply-To: <CAMuHMdWeDsAtmUq_TEFRAEY_gikAVoh=-mqwwp9OzOXobyWo+A@mail.gmail.com>
References: <CAMuHMdXhYNQ_7JOC3u7CS41mxgSKkuFYA7QdjZgeBawqMZQ9-g@mail.gmail.com>
	 <20121103101926.4e48cf8e7f3f1d3de90e45a2@canb.auug.org.au>
	 <CAMuHMdWeDsAtmUq_TEFRAEY_gikAVoh=-mqwwp9OzOXobyWo+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 09:03 +0100, Geert Uytterhoeven wrote:
> Hi Stephen,
> 
> On Sat, Nov 3, 2012 at 12:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Fri, 2 Nov 2012 19:44:48 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> http://kisskb.ellerman.id.au/kisskb/buildresult/7458505/
> >>
> >> ccache: FATAL: Could not create
> >> /scratch/kisskb/ccache/d/7/f9e308f728ef43aaa482aefb9a00a2-852386.o.tmp.stdout.Sprygo.5748
> >> (permission denied?)
> >> make[4]: *** [drivers/media/rc/ene_ir.o] Error 1
> >>
> >> http://kisskb.ellerman.id.au/kisskb/buildresult/7461979/
> >>
> >> ccache: FATAL: Could not create
> >> /scratch/kisskb/ccache/5/e/47d893acad42c07542edec1f826579-1842636.o.tmp.stdout.Sprygo.557
> >> (permission denied?)
> >> make[3]: *** [net/core/sock.o] Error 1
> >
> > Well, that is weird.  I can't find any reason for that to happen :-(
> >
> > I'll have a chat with the kisskb guy when I next see him.  Thanks for the
> > heads up.
> 
> As code is migrating to Linus' tree, it's spreading from the linux-next to the
> linus branch, e.g.:
> http://kisskb.ellerman.id.au/kisskb/buildresult/7536268/
> ccache: FATAL: Could not create
> /scratch/kisskb/ccache/1/3/a44cddb2457ad89fe496b0c82b0a09-1211932.o.tmp.stdout.Sprygo.2788
> (permission denied?)
> make[3]: *** [drivers/block/aoe/aoecmd.o] Error 1

Hi Geert,

This has started happening because of a change in ccache (v3.1.7). It
has always checked that the stdout file exists (via stat), but
previously if it was missing it would fall back to a full compile,
whereas now it is a fatal error.

However looking at the ccache code it makes no sense for the file not to
exist, because we just created it. So it's a bit of a mystery.

At the moment I'm running with a slightly hacked ccache (too much and
the bug vanishes), and auditing enabled, to try and work out if someone
is actually unlinking the file or what.

Hopefully we can sort it out in the next few days.

cheers



