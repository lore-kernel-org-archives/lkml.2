Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1GUBjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 21:39:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab1GUBjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 21:39:22 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Jul 2011 18:38:45 -0700
Message-ID: <CA+55aFxKbAXXv2x0ykezsXbSeZZQ0DwPRzYPY_QZ0NdFKes_NQ@mail.gmail.com>
Subject: Note on Linux 3.0 and the 3.1 merge window
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everybody knows by now, not only did I do an -rc7 last week instead
of releasing 3.0 (due to some worries about the RCU code), but I ended
up also not doing the 3.0 on Monday because of a pathname lookup bug
and then some _more_ RCU issues.

Anyway, those should all be resolved and the fixes merged now, and I'm
not really all that nervous about the pathname lookup issue - I think
that got nailed, and the patch for that was literally just moving a
single line (and adding a comment).

The RCU issues worries me a bit, but everything says it's all good,
and the biggest issues were with the new RCU_BOOST feature that really
neither defaults to on, nor is suggested right now. So I think we're
ok, and I'm planning on doing 3.0 tomorrow.

That said, I do have one observation, and two requests:

The observation: with the upcoming version number change, the official
'git' repository is now (and has been for a week, but people probably
didn't notice) just

    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

ie the "-2.6" thing is gone. However, the old name continues to work,
just so that nothing breaks. You don't need to really change anything,
but I thought I'd just point it out.

The two requests are pretty simple:

 - Please do spend the time doing some last-minute checking of the
current git tree. The 3.0 release hasn't really had a lot of
fundamental changes, and the pathname bug Hugh found wasn't even a
regression - it's been there a while and was in no way a 3.0 thing. So
I don't really expect any huge issues, but just for psychological
reasons it would be nice to not have even a whiff of the traditional
".0 problems" .

 - Because the 3.0 release ends up being so delayed from my original
plan, that is now pushing the merge window solidly into my summer
vacation. Originally, I'd have vacationed after -rc1. With the extra
week, the merge window pushed a couple of days into my vacation - not
enough to worry about. And now, it's solidly "the second week of the
merge window, Linus plans to spend much of the week under water". So
please try to send your merge window pull requests *early*.

So that second request is basically aiming to not have to extend the
merge window. I won't have WiFi under water, and the computer I will
have there have won't be doing git merges. But if the load is light on
the second week, I may be able to keep up despite being on vacation.
Thanks to Intel, I will at least have a very capable laptop that can
compile kernels in minutes rather than hours, and where
'allyesconfig's are actually reasonable targets for me.

If I end up not being able to do a good job while on vacation, I'll
obviously have to extend the merge window, but I'm basically hoping
that we simply won't need to go there. I just need some help from you
guys for that to work.

                                        Linus
