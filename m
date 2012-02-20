Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2BTIK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:10:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56690 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2BTIKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:10:55 -0500
Date: Mon, 20 Feb 2012 09:10:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to determine
 nested NMI
Message-ID: <20120220081045.GD30810@elte.hu>
References: <1329617173.1561.5.camel@acer.local.home>
 <20120219125601.GD25900@elte.hu>
 <1329663451.25686.21.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329663451.25686.21.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 2012-02-19 at 13:56 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > I found that it is possible for userspace to prevent an NMI 
> > > from triggering while it is running by setting its stack 
> > > pointer to that of the NMI stack. This tricks the NMI nested 
> > > algorithm in thinking that the NMI is nested. The easy 
> > > solution to this is to test the %rip to make sure that the NMI 
> > > happened in kernel mode before testing for nesting.
> > 
> > Ouch...
> 
> Note, it does not seem to cause any destruction, but screw up 
> profiling.

Except if the source of the NMI was not profiling, right?

Thanks,

	Ingo
