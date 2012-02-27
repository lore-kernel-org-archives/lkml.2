Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2B0NXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:23:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2B0NXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:23:39 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_ST7Y0qlS7IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ehPa5tgHUGONEQjP8HAA:9 a=tl_54uHMH2tQrAdczyMA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330349016.25686.185.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.3] x86: Fix up CFI for the nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>
Date: Mon, 27 Feb 2012 08:23:36 -0500
In-Reply-To: <20120227073905.GB3397@elte.hu>
References: <20120225173548.977089274@goodmis.org>
	 <20120227073905.GB3397@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, 2012-02-27 at 08:39 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > Jan posted a patch that fixes the CFI annotations. I recommend getting
> > this into 3.3 as this is new code and it would be nice to have CFI
> > correct. It also does a little simplification of it as well.
> > 
> > The second patch is comment changes only (very low impact on messing
> > anything up). I realized that the comments had some references to
> > previous approaches that I tried, and I fixed them to reflect what
> > the final result was. I also added some more comments to describe
> > the code a bit better.
> > 
> > Thanks,
> > 
> > -- Steve
> > 
> > Please pull the latest tip/x86/urgent tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > tip/x86/urgent
> > 
> > Head SHA1: 79fb4ad63e8266ffac1f69bbb45a6f86570493e7
> > 
> > 
> > Jan Beulich (1):
> >       x86-64: Fix CFI annotations for NMI nesting code
> > 
> > Steven Rostedt (1):
> >       x86: Fix the NMI nesting comments
> > 
> > ----
> >  arch/x86/kernel/entry_64.S |   64 ++++++++++++++++++++++++--------------------
> >  1 files changed, 35 insertions(+), 29 deletions(-)
> 
> I don't think we want a 30+ lines diffstat to this rather 

Some of that was just movement of code.

> non-trivial NMI codepath - and it changes real instructions, not 
> just the CFI annotations.

The changes to the real code made the CFI code easier to fix. But if you
are nervous about the code change (which actually simplifies the code),
I can ask Jan (Cc'd) to break out the patch into two changes if
possible.

I'm not sure how the CFI can handle the current trampoline, but perhaps
we can just fix the main part of the code and leave the trampoline part
broken? Then we can add the rest of the CFI changes and the movement of
the trampoline back into the function for the next release.

> 
> Also, the 'update comments' commit does not belong into 
> x86/urgent either.

Hmm, I didn't know that fixing comments was for a merge window only.
Some of the comments are currently wrong and I didn't think we would
want those in a main release. While reading the code again I realized
that I could also add more comments to make it easier to understand. I
would think that comments would be fine for the -rc releases because
they have almost no chance of introducing bugs.


> 
> So either you do an obviously trivial patch that only adds CFI 
> annotations and nothing else, or I can pull these bits into 
> tip:x86/debug, for a v3.4 merge.

I'm fine with waiting for v3.4 before these changes get in.

-- Steve


