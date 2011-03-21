Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1CUNzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:55:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36899 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1CUNzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:55:22 -0400
Date: Mon, 21 Mar 2011 14:55:14 +0100
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
Message-ID: <20110321135513.GA6397@gere.osrc.amd.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net>
 <20110319193954.GA2032@redhat.com>
 <1300713980.16880.5813.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300713980.16880.5813.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 09:26:20AM -0400, Steven Rostedt wrote:
> On Sat, 2011-03-19 at 15:39 -0400, Dave Jones wrote:
> 
> > Something that has crossed my mind over the last few days was the idea
> > of splitting checkpatch into two tools.
> > One for checking CodingStyle issues, and one for checking for actual
> > code problems like the memset example.
> > 
> > The motivation for such is that I think it's pretty clear that many maintainers
> > never run checkpatch on patches they queue up before pushing to Linus...
> > 
> > $ scripts/checkpatch.pl  ~/Mail/upstream/2.6.39/head-March-18-2011 | wc -l
> > 2361
> > 
> 
> I run it on all my patches. But there are some warnings that I ignore.
> Sometimes I don't split the 80char lines if doing so makes the code even
> uglier.

Same here, certain warnings checkpatch spits are plain dumb in certain
situations. What we want is to fix checkpatch to warn/error out only
on real issues which are valid 100% of the cases and stick all the
remaining, not-always-an-issue stuff which deserves a warning only
sometimes behind a "--pedantic" or "--extended-checks" option or
whatever.

> > The bulk of this is all "missing space here" "don't put a space there" type
> > fluff that most maintainers just don't care about.  Any valuable warnings
> > are lost in the noise.  If we had a separate tool to check for real flaws,
> > (or even a way to suppress the stylistic warnings from the existing one)
> > maybe more maintainers would run their changes through it.
> 
> As I replied with my phone, having a suppress warnings would be nice.
> 
> checkpatch -e patch
> 
> where -e is errors only?

Yeah, let's enable the errors-only checking by default, i.e. no args and if you
want additional ones, you need to switch on an option.

> > 
> > I dunno, maybe I'm just a crazy dreamer too, but I think many people
> > have written checkpatch off as useless in its current incarnation.
> 
> Well I and I'm sure Ingo use it quite a bit. I'm sure there are others
> that do too.

Yep, I have it as a pre-commit hook in git and it helps a lot. However,
sometimes I need to do '--no-verify' on false positives.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
