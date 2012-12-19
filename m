Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2LSQ3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:29:53 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35460 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2LSQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:29:46 -0500
MIME-Version: 1.0
In-Reply-To: <50D1D373.5060301@kernel.dk>
References: <50CF89EB.2030109@kernel.dk> <20121218092554.GA3823@gmail.com>
 <50D056A5.3040501@kernel.dk> <CA+55aFzhfknCd-JERhrDfkOhdm_eytoVBYA42ex2K+BghBaBKQ@mail.gmail.com>
 <50D1D373.5060301@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Dec 2012 08:29:25 -0800
X-Google-Sender-Auth: vs49Ylj0AkHUq54km036CQNEFOg
Message-ID: <CA+55aFx71aA5_eX1=DjKG-Wd0u9YeryD6FeAk9HJ1DnxRTwPoA@mail.gmail.com>
Subject: Re: [boot crash] Re: [GIT PULL[ block drivers bits for 3.8
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@fusionio.com>, Neil Brown <neilb@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 6:47 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> It should all just be in sectors. The limits set are in bytes (could be
> sectors too, but doesn't matter so much), but any interface operates in
> sectors.
>
> I'm happy with your proposed fix. I think you should shove it in there,
> then I'll make sure we get it cleaned up for 3.9.

Ok, committed and pushed out. Neil, can you please test it on whatever
raid setting you can have?

In particular, it would be interesting to make sure it works correctly
even without LBD support on 32-bit devices on partitions that start
more than 4GB into the device, because that's the case I think was
broken before.

> Of course it's been tested. Granted it got moved over too late (as 1 of
> 2 that did), but I've run the branch on a multitude of systems.
> Apparently none of them hit the case of having a zero granularity
> reported, so never hit the bug.

I presumably happens on pretty much anything that doesn't have
discard. Of course, I've personally gotten rid of any rotating devices
I have, but it still sounds like there's a big testing hole somewhere.

              Linus
