Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321Ab0HFTDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:03:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965296Ab0HFTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 11:40:15 -0700
Message-ID: <AANLkTikhq6FF4j+w-TXrPeq05NhvbhgqhJkW7tCw2+3c@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
To: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 2:35 PM, Greg KH <gregkh@suse.de> wrote:
>
> This contains the big BKL removal of the tty layer, which has been
> worked on now for a long time by Alan and Arnd.

Umm. No it doesn't.

It contains some crazy "BKL or mutex" choice layer, and the MUTEX
choice is disabled unless you have EXPERIMENTAL set (and not the
default even if it is set - but quite frankly, that doesn't matter,
because asking about it is so fundamentally wrong in the first place
that the whole default choice is totally meaningless).

That's just total and utter crud. Having a conditional BKL is _worse_
than just having the BKL. It's crazy. It's stupid, it limits testing,
and it's pure idiocy. Whoever thought that was a good idea was not
thinking at all.

Either the locking fixes are improvements, or they aren't. If they are
improvements, they should be unconditionally enabled, and the old
locking should have been removed. And if they aren't, it shouldn't
have been merged at all. The timid kind of "let the user choose"
choice is STUPID.

Dammit, if the developer doesn't know which one is better, how the
hell is a user supposed to know? Answer: he isn't. Making it a config
option is fundamentally wrong.  Config options that ask questions that
users cannot answer are WRONG. Really.

I'm not pulling crazy sh*t like this. The _only_ thing that kconfig
option does is basically mean that it doesn't get the kind of coverage
in testing that it needs to get, and it confuses everybody. Not to
mention having two totally different code-paths where there should be
only one.

Do do the highlander thing on that crud. Cut it off at the head, and
make sure it never ever comes back to life.

                  Linus
