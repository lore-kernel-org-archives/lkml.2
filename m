Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab2DAIeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:34:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51906 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2DAIeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:34:11 -0400
Date: Sun, 1 Apr 2012 10:34:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: Linux 3.4-rc1
Message-ID: <20120401083406.GA21108@gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...]
> 
> One thing worth pointing out is that the header file cleanups 
> were nice, but let's never do them again. Or at least not for 
> a release or two. They caused a lot of merge conflicts and 
> small annoyances, and while I'm ok with resolving merges, it 
> was annoying enough that I don't want to go through that 
> immediately again. I know they also annoyed some 
> submaintainers that were complaining to me about the pain.

I wasn't amongst those complaining and I agree with the system.h 
elimination cleanup, but I think it's better to do these right 
at -rc1 time instead of during -rc0 ...

There's very little complex testing needed: only build coverage 
on architectures and key configs - one iteration of linux-next 
exposure will do that.

So acks can be gathered, it can be rebased to -rc1 or almost-rc1 
and can be pulled in (or conflict-merged), before folks grow a 
large development tree again.

> That said, I do think they helped. The <asm/system.h> 
> disintegration (and to a smaller degree the bug.h cleanups) 
> may have been painful, but it definitely cleaned things up. 
> [...]

Agreed. We probably need a similar sched.h, fs.h and mm.h 
splitting/elimination/shrinking pass as well :-)

> [...] So I guess we *will* do things like this in the future 
> again, I just want to forget about the pain before we embark 
> on this next time. Ok?

I think this kind of pain is largely avoidable via proper timing 
- this one simply wasn't timed properly - pulling it in in the 
middle of the merge window was rather crazy and I think you 
regretted it on the next morning! ;-)

Thanks,

	Ingo
