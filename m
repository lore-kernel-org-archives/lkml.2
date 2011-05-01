Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318Ab1EASUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:20:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465Ab1EASUq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:20:46 -0400
MIME-Version: 1.0
In-Reply-To: <web-516277136@zbackend1.aha.ru>
References: <web-516164730@zbackend1.aha.ru> <BANLkTimda-mi2rjgnX0jqg7Pg-J6HSDb6w@mail.gmail.com>
 <web-516277136@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 May 2011 11:20:21 -0700
Message-ID: <BANLkTin=zhUfceHOg3i3BomYEa2kZm1cjQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/1 werner <w.landgraf@ru.ru>:
>
> But, now, the 2nd compilation, I made with the slackware huge configuration.
> And this works !! It boots normally, and it also don't crash šif unzipping
> big files. šSo you were right, to use a more little config, for find out
> better the reason.

Ok, good. Now we have confirmation that it's not the SATA driver
itself that causes problems, it's some other driver.

So what I'd suggest you try to do is a "config bisect" to see exactly
_what_ config option it is that makes things break. Steve Rostedt
wrote a tool ("ktest") for this exact thing, but I'm not entirely sure
that it will work for your situation. I've added Steve to the email
participants, and I'd suggest you read up on it:

  http://lwn.net/Articles/414064/

would seem to be a good starting point.

Of course, you could just try to do it manually too - just turn one
subsystem at a time from a module in the working slackware config into
a compiled-in thing, so that eventually you end up with the
non-working "almost everything compiled in" case. And see which
subsystem it is that causes problems.

And then when you find the subsystem that makes the problem re-appear,
you'd need to go back and try each driver at a time.

                         Linus
