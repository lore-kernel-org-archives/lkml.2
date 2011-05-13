Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab1EMIiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:38:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42011 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab1EMIit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:38:49 -0400
Date: Fri, 13 May 2011 09:37:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
Message-ID: <20110513083738.GA19733@n2100.arm.linux.org.uk>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au> <20110513080634.GA13647@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513080634.GA13647@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 10:06:34AM +0200, Ingo Molnar wrote:
> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > Today's linux-next merge of the tip tree got a conflict in 
> > arch/x86/kernel/i8253.c between commit 3490f584b9ba ("clocksource: convert 
> > x86 to generic i8253 clocksource") from the arm tree and commit b01cc1b0eae0 
> > ("x86: Convert remaining x86 clocksources to clocksource_register_hz/khz") 
> > from the tip tree.
> > 
> > The former seems to supercede the latter, so I used the former.
> 
> Russell, how the heck did this commit:
> 
>  commit 3490f584b9ba5a0b6f63832fbc9c5ec72506697b
>  Author:     Russell King <rmk+kernel@arm.linux.org.uk>
>  AuthorDate: Sun May 8 18:55:19 2011 +0100
>  Commit:     Russell King <rmk+kernel@arm.linux.org.uk>
>  CommitDate: Tue May 10 08:20:54 2011 +0100
> 
>     clocksource: convert x86 to generic i8253 clocksource
> 
> which has such a clearly x86 diffstat:
> 
>  arch/x86/Kconfig             |    1 +
>  arch/x86/include/asm/i8253.h |    2 +
>  arch/x86/kernel/i8253.c      |   79 +-----------------------------------------
>  3 files changed, 4 insertions(+), 78 deletions(-)
> 
> end up in the ARM tree without an ack from an x86 maintainer??

The "no response" means two things: either that people are busy, or people
don't care about the patch.  There is a patch from David Martin modifying
linux/elf.h adding one line to it which has not had any response.  Should
we assume the silence means that people are busy?  If we did that, nothing
would ever happen.

> I see the commit has an ack from John but that feedback is not visible in the 
> lkml thread of this patch nor did John really realize the conflict nor the 

I have no idea why John's ack is not visible, especially as it was sent
to lkml _and_ explicitly copied to you.

> build breakage. The patch was still in the to-be-reviewed queue of our patches.
> 
> Nor was it tested properly. The patch looks sane but your workflow sucks.
> Please revert it and use a proper Git workflow to change arch/x86/ details ...

I don't think so.  I created a patch.  I posted it to relevant people.
I got an ack.  So I put it into linux-next for further testing rather
than having it sitting around here getting zero testing.

That's the _proper_ thing to do.  linux-next found some problems, so
let's sort them out - great, that's what linux-next is there for.  Let's
sort them out instead of assigning blame.

And hey, it found a problem, and the problem has now been fixed.  Which
is great, and that should be visible to linux-next soon.

As for merge conflicts, they happen.  They get sorted.  It's no big deal.
Again, that's what linux-next is there to find and allow people to
_discuss_ how to resolve them.  It's not about avoiding all conflicts
no matter what or blaming people when conflicts happen.

Lastly, I have absolutely no problem about pulling the x86 bits out of
this series if they cause a conflict or don't get an ack.  I operate a
flexible approach to my git tree for stuff like this which allows stuff
to be dropped or updated as necessary.
