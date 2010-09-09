Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab0IIAVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 20:21:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194Ab0IIAVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 20:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <201009082255.33035.arnd@arndb.de>
References: <201009082255.33035.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Sep 2010 17:20:57 -0700
Message-ID: <AANLkTikfLb+kDZN8aodPwxFuL_VOuyb7AH=eF60MwrWG@mail.gmail.com>
Subject: Re: [RFC] annotating the remaining BKL users
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>, Jan Blunck <jblunck@suse.de>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 1:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I'd like to hear preferences for one approach or the other,
> especially from Linus, so we can give this some better testing
> in -next before the merge window.

Hmm. I like your patch. It seems to have a good balance of "select
BKL" (for architectures that require it for some reason) and "depends
on BKL" (for individual modules).

That said, I'd also like to see a comment _why_ the architectures in
question depends on the BKL. Some of those look pretty historical (the
sparc32 register window spill code? Does it _really_ need the BKL at
all, or is that just a remnant of "let's get the BKL at each kernel
entry").

So with the added rule that "each select BKL needs a quick comment
why", I'd be happy with it. And maybe it would make people take a
second look.

                             Linus
