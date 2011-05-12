Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab1ELRit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:38:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758281Ab1ELRiq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 10:37:53 -0700
Message-ID: <BANLkTi=YDZa+BRaG90vJsjrT9VxgySrDRQ@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, git@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:15 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> OK, this sucks.  In the course of bisecting this, I've hit two other
> apparently unrelated bugs that prevent my from testing large numbers
> of kernels.  Do I have two questions:
>
> 1. Anyone have any ideas from looking at the log?

Nope, that doesn't look very helpful.

> 2.  The !&$#@ bisection is skipping all over the place.  I've seen
> 2.6.37 versions and all manner of -rc's out of order.

That's the _point_ of bisection. It jumps around. You can start off
trying to pick points on my development tree, but I only have a
hundred merges or so. You're going to start delving into the actual
development versions very quickly. And if you don't do it early,
bisection is going to be much much slower, because it's not going to
pick half-way points.

So bisection works so well exactly because it picks points that are
far away from each other, and you should just totally ignore the
version number. It's meaningless. Looking at it just confuses you.
Don't do it.

Now, "pick stable points" would obviously be nice, but that is going
to have to be manual. You can certainly make some helper scripts, and
that's where that "--first-parent" thing comes in. So if you want to,
just use "git bisect reset" to the commit you want to test.

If you think it's networking, for example, and you've bisected into
there but aren't sure, do "gitk --bisect", find the point where I
merge, and pick that (and my parent), and "git bisect reset" those
points. That way you can verify that it's the networking merge (or
verify that it isn't).

                         Linus
