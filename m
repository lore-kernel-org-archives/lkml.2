Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1E2SYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:24:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51327 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1E2SY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:24:29 -0400
Date: Sun, 29 May 2011 19:23:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110529182356.GJ11521@ZenIV.linux.org.uk>
References: <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <8762otqwke.fsf@linux.vnet.ibm.com>
 <BANLkTimuixiwGS0VkWBiB63pzMov8ZB62Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimuixiwGS0VkWBiB63pzMov8ZB62Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 10:02:06AM -0700, Linus Torvalds wrote:

> And yes, it is absolutely acceptable. The only questions in my mind are
> 
>  - why haven't we done this long ago?
> 
>  - do we have the flag space?
> 
>  - should we do a O_NOMNT_PATH flag to do the same for mount-points?
> 
>   Some people worry about being confused by bind mounts etc.
> 
>  - do we think ".." is worthy of a flag too?
> 
>    or is that a "user space can damn well check that itself, even if
> it would be absolutely trivial to check in the kernel too"?
> 
> Whatever. I think the NOFOLLOW_PATH one is pretty much a no-brainer.
> It's not like symlink worries are unusual.

It's not *quite* a no-brainer.  Guys, please hold that one off for a while;
we have more massage to do in the area and I *really* want to get atomic
open work finished (== intents gone, revalidation vs mountpoints sanitized,
etc.) before anything else is done to fs/namie.c.  OK?

And as for .. - userland can bloody well check that on its own if it cares.
Let's keep it simple, please - we already have things far too complicated
in there for my taste.
