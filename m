Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab0KSXWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:22:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756159Ab0KSXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:22:23 -0500
MIME-Version: 1.0
In-Reply-To: <1290201154.2116.29.camel@morgan.silverblock.net>
References: <1290201154.2116.29.camel@morgan.silverblock.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Nov 2010 15:22:00 -0800
Message-ID: <AANLkTi=fnFhznMz2bTRSJDrfeDwsVUTyqiKDATPzEjhq@mail.gmail.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
To: Andy Walls <andy@silverblocksystems.net>
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 1:12 PM, Andy Walls <andy@silverblocksystems.net> wrote:
>>
>> If it actually breaks user-space, I think we should just revert it.
>
> User space klogd is what's broken in this case:

Sure. I'm not surprised. I didn't really expect the /proc/kallsyms
mode change to trigger anything like what Sarah reported, and
user-space just being buggy because the error case had never even been
tested is quite understandable.

But the thing is, it doesn't even matter.

The rule is not "we don't break non-buggy user space" or "we don't
break reasonable user-space". The rule is simply "we don't break
user-space".

Even if the breakage is totally incidental, that doesn't help the
_user_. It's still breakage.

We still have magic scheduler debug options to run children before
parents after fork, simply because that used to _hide_ a race
condition in some older "bash" versions (or maybe it was the other way
around, whatever).

The thing is, bugs happen. And if they never had test coverage, we
can't blame people for them. Saying "tough luck, we changed it, and
you did something wrong" may be manly, but it's also unacceptable. The
developer may fix his bug, but there's still users out there.

Now, there _are_ exceptions. There are always exceptions. Intelligent
people don't run things off a script, and it's obviously always to
some degree a judgment call. The breakage has to be balanced against
the upsides. If the kernel behavior change is due to some fundamental
security issue or a major redesign that we _had_ to do to make
progress, and the user-level breakage is reasonably well-contained,
we'll just say "sorry, we had to do it".

In this case, the upside just wasn't big enough to accept _any_
breakage, especially since people and distributions can just do the
"chmod" themselves if they want to. There was a lot of discussion
whether the patch should even go in in the first place. So this time,
the "let's just revert it" was a very easy decision for me.

              Linus
