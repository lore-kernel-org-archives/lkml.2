Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab2AJTTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:19:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63129 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab2AJTTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120110184530.GE7164@opensource.wolfsonmicro.com>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com> <20120110184530.GE7164@opensource.wolfsonmicro.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 11:18:44 -0800
X-Google-Sender-Auth: 473cEo-nmbvG5HjxiotLXz_4Hpw
Message-ID: <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
Subject: Re: Regulator updates for 3.3
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 10:45 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
> Hrm, OK.  These merges are all merges up of bug fixes for -rc from my
> own tree into the development code which I tend to do constantly to make
> it easier to work directly on the development branch.  What's the best
> practice here - push things to you a bit more aggressively and wait
> until you've tagged a -rc and then merge that back up into the
> development branch?

No. Just don't do the merges. If your development tree isn't stable on
its own, then there is something seriously wrong in what you do.

Doing *one* or two merges during the cycle might be ok just to not get
too far out, but you have way way WAY too many of them.

Just do this:

    gitk d52739c62e00..269d430131b6

to see what I actually got, and then look at what you did on Nov 27,
for example. You did *two* of the merges within hours of each other!
And then you had two more the very next day, without even having any
actual development in between! That's just crazy. The fact that you
then say that you have some kind of *excuse* for that craziness is
just sad.

Stop doing that. It's stupid. It just makes it harder for everybody to
see what you are doing. You didn't even do any *development* in that
tree, you just did a few merges in a row because *some other tree* had
done development! Followed up by a three-way merge where one of the
points was *again* that useless one. Can't you see how crazy that is?

And the "two consecutive merges with no development in between" is
just the extreme case of that. It's wrong in general, that extra crazy
case is just the extreme example of what kind of crap happens when you
think that you should track another unrelated branch in your
"for-next" branch.

You shouldn't do that. It's your development branch. You shouldn't
track the "for-linus" branch in it.

                          Linus
