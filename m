Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2AJWyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:54:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43486 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJWys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:54:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120110222711.GK7164@opensource.wolfsonmicro.com>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 14:54:27 -0800
X-Google-Sender-Auth: xCqIsQ7YZkUlLzTFpFo2HRARxGE
Message-ID: <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
Subject: Re: Regulator updates for 3.3
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 2:27 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
> Especially in the cases where the lack of the bug fix breaks the new
> code it sems sensible enough to want to do the merges so that the
> history includes things that actually work.

So I don't mind merges if they have a lear reason for existing.

This is actually one of my major gripes with the git UI, and one of
the few areas where I really think I screwed up: I made merging *too*
easy by default. I should have made it always start up an editor for a
merge message, the way it does for a commit - rather than just do a
trivial pointless merge without even asking the user for a reason for
the merge.

So looking at that almost two months of regulator history in

   gitk d52739c62e00..269d430131b6

I would not have reacted badly at all if there were one or two of
those merges, and they actually had a reason associated with them.
Sadly, due to that git UI mess-up, that's harder to do than it should
be. Oh, it's easy enough with "git merge --no-commit" followed by just
"git commit", and then you get the normal git editor window.

So right now "git merge" (and "git pull") make it too easy to make
those meaningless merge commits. If instead of seven pointless merges
you had (say) had two merges that had messages about *why* they
weren't pointless, I'd be perfectly happy.

Addid junio and git to the cc just to bring up this issue of bad UI
once again. I realize it could break old scripts to start up an editor
window, but still..

                       Linus
