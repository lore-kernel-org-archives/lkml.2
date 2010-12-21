Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab0LUCLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 21:11:08 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:52361 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab0LUCLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 21:11:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eVSDudECl6ga7h7UPddr7a+o+Qiuh+MbxI5a9utibVYjQeyLPUg7NE8Ua/8vnn7Z86
         rTz5f7OlT/3q3KzCf/f+Uu2DdsetO8RxmMDzLzYk6t/PJMOSDFwyut+r2AB+vh3y3HiL
         R7rY+FxCZhAvl0DSRG18q8fpFG5qZi/3mcYKM=
Date: Tue, 21 Dec 2010 03:10:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 06/15] nohz_task: Keep the tick if rcu needs it
Message-ID: <20101221021046.GQ1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-7-git-send-email-fweisbec@gmail.com>
 <1292860700.5021.14.camel@laptop>
 <20101220234934.GD1715@nowhere>
 <20101220171259.1d3cb6ad@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220171259.1d3cb6ad@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:12:59PM -0700, Jonathan Corbet wrote:
> On Tue, 21 Dec 2010 00:49:38 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Nope, the new config can only be built after [RFC PATCH 11/15] x86: Nohz task support
> > 
> > I know I split up the patches in some unusual way but I did that on purpose:
> > I wanted to have a finegrained patchset so that it's more reviewable than a big
> > "core support" - "arch support" dual patch based style.
> > 
> > But I ensured the new config can not be enabled before it's entirely buildable
> > and has no known bugs.
> 
> Which is a nice thought (it helped me to understand the patches - article
> forthcoming)

Oh great :)

> but there is a downside: if anybody tries to bisect a
> problem, they'll end up at #11.  This stuff is sufficiently tricky that it
> would be nice to be able to bisect a little closer to the patch which
> actually introduced a bug.


Yeah indeed. I think I could split that up another way while keeping the fine
grained progression (if any).

I could enable the interface and CONFIG a bit sooner, once we have the support
for tick stop and restart handling basic things like woken up tasks and rcu
pending works checks.
And then handle the rcu extended grace periods in userspace later.
Because it works without, the nohz task would just be regularly interrupted by
rcu IPIs to note the quiescent states.

There are lots of changes to be done anyway, so I'm sure there will be enough
new takes of this for me to train more patchset split-up flavours ;-)
