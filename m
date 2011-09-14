Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024Ab1INWhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 18:37:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36696 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1INWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 18:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1109141427190.29355@sister.anvils>
References: <1315941801.2565.19.camel@edumazet-laptop> <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com>
 <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com>
 <1315983230.2565.28.camel@edumazet-laptop> <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com>
 <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com>
 <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1315990519.29510.119.camel@sli10-conroe> <alpine.LSU.2.00.1109141337080.29178@sister.anvils>
 <1316033750.2835.2.camel@edumazet-laptop> <alpine.LSU.2.00.1109141427190.29355@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Sep 2011 15:37:19 -0700
X-Google-Sender-Auth: SkqWzMz-14VX0O4PeAEUwQJpNJo
Message-ID: <CA+55aFyzjX9kkHZUVg=zZsOQjq1xoNBk2QvJjjnbUx3BOF5Fzg@mail.gmail.com>
Subject: Re: [BUG] infinite loop in find_get_pages()
To: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Pawel Sikora <pluto@agmk.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 2:53 PM, Hugh Dickins <hughd@google.com> wrote:
>
> Thanks, Eric, though it may not be worth spending your time on it.
> It occurred to me over lunch that it may take painfully longer than
> expected to invalidate_mapping_pages() on a single-swapped-out-page
> 1TB sparse tmpfs file - all those "start += 1" restarts until it
> reaches the end.

So can we have a stop-gap patch to just fixes it for now? I assume
that would be Shaohua's patch with the "nr_found > nr_skip" change?

Can you guys send whatever patch is appropriate for now with a nice
changelog and the appropriate sign-offs, please? So that we can at
least close the issue...

                       Linus
