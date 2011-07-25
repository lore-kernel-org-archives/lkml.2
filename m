Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab1GYRyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:54:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab1GYRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:54:29 -0400
MIME-Version: 1.0
In-Reply-To: <1311588599.2617.56.camel@laptop>
References: <20110722125236.GA24832@elte.hu> <CACqU3MUW81UmBK7qBQCZRqzfosrukYM9=o0EZP_DvSjgywfK8g@mail.gmail.com>
 <1311588599.2617.56.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Jul 2011 10:53:32 -0700
Message-ID: <CA+55aFwxqVXb0cFrkgdrDH4J_aF9J7iw8i6ypAda2HiAyeFYpw@mail.gmail.com>
Subject: Re: [GIT PULL] core/locking changes for v3.1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 3:09 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Argh, I really need -Werror to even see warnings, compiler output just
> flies by waaaaaay too fast.

Do what I do:

  make -j32 > ../makes

that way the only thing you see is the warnings (and the final link report).

That pattern was one reason why I wanted me default compile to be
warning-clean. Of course, then gcc started adding more warnings, and
it's not clean any more ("warning: statement with no effect" from the
fact that we just define many functions to '(0)' when they are
disabled) but my current personal compile config only gets four
warnings.

I realize there are *many* more warnings once you start enabling more
special code - as usual, the core code tends to be better quality, and
the further away from that base you get, the worse things get.

But it would definitely be good if most kernel developers did the
above. Do it for just your personal config - at least you'll see the
warnings in code you write (because presumably your personal config
will have that code enabled ;)

                    Linus
