Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1CSTkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 15:40:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1CSTk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 15:40:28 -0400
Date: Sat, 19 Mar 2011 15:39:55 -0400
From: Dave Jones <davej@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
Message-ID: <20110319193954.GA2032@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Whitcroft <apw@shadowen.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317211548.646b04d2@tpl.lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 09:15:48PM -0600, Jonathan Corbet wrote:
 > On Thu, 17 Mar 2011 22:52:24 -0400
 > Steven Rostedt <rostedt@goodmis.org> wrote:
 > 
 > > The use of kzalloc() is preferred over kmalloc/memset(0) pairs.
 > > 
 > > When a match is made with "memset(p, 0, s);" a search back through the
 > > patch hunk is made looking for "p = kmalloc(s,". If that is found, then
 > > a warning is given, suggesting to use kzalloc() instead.
 > 
 > The Coccinelle stuff already has a lot of this kind of test.  See, for
 > example, scripts/coccinelle/api/alloc/kzalloc-simple.cocci.  Suppose
 > there is some way all this nice analysis infrastructure could be
 > integrated instead of duplicated?  Or am I just a crazy dreamer?

Maybe.  Coccinelle is one of those tools that seems to be perpetually
on my "to look into" list that I never get around to.


Something that has crossed my mind over the last few days was the idea
of splitting checkpatch into two tools.
One for checking CodingStyle issues, and one for checking for actual
code problems like the memset example.

The motivation for such is that I think it's pretty clear that many maintainers
never run checkpatch on patches they queue up before pushing to Linus...

$ scripts/checkpatch.pl  ~/Mail/upstream/2.6.39/head-March-18-2011 | wc -l
2361

The bulk of this is all "missing space here" "don't put a space there" type
fluff that most maintainers just don't care about.  Any valuable warnings
are lost in the noise.  If we had a separate tool to check for real flaws,
(or even a way to suppress the stylistic warnings from the existing one)
maybe more maintainers would run their changes through it.

I dunno, maybe I'm just a crazy dreamer too, but I think many people
have written checkpatch off as useless in its current incarnation.

	Dave

