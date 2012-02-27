Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2B0HjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:39:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab2B0HjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:39:18 -0500
Date: Mon, 27 Feb 2012 08:39:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.3] x86: Fix up CFI for the nested NMI
Message-ID: <20120227073905.GB3397@elte.hu>
References: <20120225173548.977089274@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120225173548.977089274@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Jan posted a patch that fixes the CFI annotations. I recommend getting
> this into 3.3 as this is new code and it would be nice to have CFI
> correct. It also does a little simplification of it as well.
> 
> The second patch is comment changes only (very low impact on messing
> anything up). I realized that the comments had some references to
> previous approaches that I tried, and I fixed them to reflect what
> the final result was. I also added some more comments to describe
> the code a bit better.
> 
> Thanks,
> 
> -- Steve
> 
> Please pull the latest tip/x86/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/x86/urgent
> 
> Head SHA1: 79fb4ad63e8266ffac1f69bbb45a6f86570493e7
> 
> 
> Jan Beulich (1):
>       x86-64: Fix CFI annotations for NMI nesting code
> 
> Steven Rostedt (1):
>       x86: Fix the NMI nesting comments
> 
> ----
>  arch/x86/kernel/entry_64.S |   64 ++++++++++++++++++++++++--------------------
>  1 files changed, 35 insertions(+), 29 deletions(-)

I don't think we want a 30+ lines diffstat to this rather 
non-trivial NMI codepath - and it changes real instructions, not 
just the CFI annotations.

Also, the 'update comments' commit does not belong into 
x86/urgent either.

So either you do an obviously trivial patch that only adds CFI 
annotations and nothing else, or I can pull these bits into 
tip:x86/debug, for a v3.4 merge.

Thanks,

	Ingo
