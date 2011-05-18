Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1ERUvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:51:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab1ERUvP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 May 2011 13:50:19 -0700
Message-ID: <BANLkTimY+y3vXa0R7Evs6dYLVjJ==KVq1A@mail.gmail.com>
Subject: Re: New boot time message: detected capacity change
To: Tony Luck <tony.luck@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 1:32 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Today's pull from Linus' tree (HEAD = 258-ga2b9c1f) gave me some new
> messages during boot:
>
> sda: detected capacity change from 0 to 146815737856
> sdb: detected capacity change from 0 to 146815737856
>
> They weren't there yesterday (HEAD = 211-gc1d10d1) ... nor do they
> show up in any of my saved boot time dmesg files for the last few
> months.
>
> Harmless?  Or something to worry about in the last few commits
> before 2.6.39 goes final?

I htink it's 02e352287a40 ("block: rescan partitions on invalidated
devices on -ENOMEDIA too"), which was reported to fix a bugzilla
entry.

However, now that I look closer, that bugzilla entry was two years old
and reported for 2.6.29.

So it wasn't a regression fix like the changelog made me think (with a
stable pointer for 38)

Jens, Tejun - stop this messing around! The block layer has been one
of the problem children in the last releases, the *LAST* thing we need
is things like this happening this late in the -rc series!

Seriously. I'm really upset. I need to be able to trust you, and you
are not being trust-worthy. F*&^ you, in other words. This was *NOT* a
regression.

I don't care if it fixes a long-standing bug, you do not send fixes
like that to me. It should have gone into the merge window for 40, and
at *that* point it might be marked for stable.

As it was, I feel that those commit descriptions were actively
misleading me into thinking this was a regression.

Maybe it won't cause any problems, but -rc7 is not the time to make
these kinds of experiments!

                         Linus
