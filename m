Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2HIMhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:37:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49279 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2HIMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:37:53 -0400
Date: Thu, 9 Aug 2012 14:37:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 3/4] ftrace: Do not test frame pointers if -mfentry is used
Message-ID: <20120809123746.GC11413@one.firstfloor.org>
References: <20120807193845.146666357@goodmis.org> <20120807194059.773895870@goodmis.org> <5021EC6B.7020605@hitachi.com> <1344430148.6935.17.camel@gandalf.stny.rr.com> <CA+55aFyVb5FE1t5zj7WJR3c=3PnCjwNd=UgC5eFdn5eV5PsEZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVb5FE1t5zj7WJR3c=3PnCjwNd=UgC5eFdn5eV5PsEZw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 06:45:37AM +0300, Linus Torvalds wrote:
> On Wed, Aug 8, 2012 at 3:49 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > No, CONFIG_HAVE_FENTRY just means fentry is supported, it does not mean
> > that it is being used. It only gets used if CC_USING_FENTRY is set,
> > which is set by the Makefile at time of compile.
> 
> Btw, it might be lovely to consider the concept of "Kconfig variables
> set by shell-scripts".

I looked into it some time ago because I needed it for something else.
But no mergeable patch produced. Will try again.

One issue was that it will break some odd cross compiling or ccache
setups where the compiler is not set correctly at config time. 
But I think it would be worth it.

> We currently have a metric sh*t-ton of Makefile magic for testing
> various things like this, and integrating it into Kconfig might be a
> good idea. That way you would be able to use the Kconfig logic on
> these things.

Also another big win would be to make the empty do nothing build faster,
because the decisions would be cached.

I measured recently and we execute 30+ gccs on a empty build.

-Andi
