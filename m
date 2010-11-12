Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0KLQZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:25:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932533Ab0KLQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:25:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011110021320.12522@skynet.skynet.ie>
References: <alpine.DEB.2.00.1011110021320.12522@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Nov 2010 08:24:48 -0800
Message-ID: <AANLkTik8-=Ku+4k0+KVZknAgx2zJGRo-n10jaNW-fke6@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 4:24 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> I've started taking Chris's pull requests now, so all the intel drm
> changes should start coming via my tree always now, unless they are pretty
> exceptional or I'm away.

Btw, Chris - don't do this:

  commit 08deebf98783d3de553eed2c9b6b8dcc7e168567
  Author: Chris Wilson <chris@chris-wilson.co.uk>
  Date:   Fri Nov 5 08:56:38 2010 +0000

    drm/i915/ringbuffer: Use the HEAD auto-reporting mechanism

    My Sandybridge only reports 0 for the ring buffer registers, causing it
    to hang as soon as we exhaust the available ring. As a workaround, take
    advantage of our huge ring buffers and use the auto-reporting mechanism
    to update the status page with the HEAD location every 64 KiB.

    Cherry-picked from 6aa56062eaba67adfb247cded244fd877329588d.

    ...

Think about what that "Cherry-picked from 6aa56062eaba.." means for a while.

It's a totally random number that is entirely pointless. That commit
doesn't exist in any trees anybody else is aware of, so it's pure and
utter noise. It has no meaning.

The only SHA1 numbers that are meaningful are numbers that are in some
history that is relevant. So a SHA1 should normally only ever point to
a commit that exists in the history of the commit that it points to
(think reverts, or "this fixes an issue introduced in xyz"). So if you
see that commit description, you're pretty much guaranteed that the
SHA1 makes sense.

The one exception is when you point to some "known external tree" - ie
the stable tree has references to the commits in the upstream kernel,
even though they are obviously not in the history of the stable commit
itself. The numbers may not make sense within the confines of just the
stable tree at the time, but at the same time, the stable tree rules
are very much that commits only get in once they are in mainline, so
there are actual rules in place basically saying that the hash makes
sense even _if_ it refers to an outside tree.

But when you cherry-pick it from some random internal tree that nobody
will necessarily ever see, and that you don't even describe what it
is, it's only pure confusion. I do

  [torvalds@i5 linux]$ git show 6aa56062eaba67adfb247cded244fd877329588d
  fatal: bad object 6aa56062eaba67adfb247cded244fd877329588d

and so will everybody else. So from a documentation standpoint, you're
actually adding negative information. Please don't.

                         Linus
