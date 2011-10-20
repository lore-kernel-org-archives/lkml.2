Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1JTGve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:51:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39196 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1JTGvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <201110200830.22062.pluto@agmk.net>
References: <201110122012.33767.pluto@agmk.net> <CA+55aFwf75oJ3JJ2aCR8TJJm_oLireD6SDO+43GveVVb8vGw1w@mail.gmail.com>
 <alpine.LSU.2.00.1110191234570.6900@sister.anvils> <201110200830.22062.pluto@agmk.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Oct 2011 23:51:11 -0700
X-Google-Sender-Auth: iq2F3qYzjJemZIpUe_jbq-Ko-TY
Message-ID: <CA+55aFwU-xwg=5ZDqsA1xwKsjeTT=8uDRygCJoW1ya7-QBitSw@mail.gmail.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@agmk.net>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/19 Paweł Sikora <pluto@agmk.net>:
>
> the latest patch (mm/migrate.c) applied on 3.0.4 also survives points
> 1) and 2) described previously (https://lkml.org/lkml/2011/10/18/427),
> so please apply it to the upstream/stable git tree.

Ok, thanks, applied and pushed out.

> from the other side, both patches don't help for 3.0.4+vserver host soft-lock
> which dies in few hours of stressing. iirc this lock has started with 2.6.38.
> is there any major change in memory managment area in 2.6.38 that i can bisect
> and test with vserver?

I suspect you'd be best off simply just doing a full bisect. Yes, if
2.6.37 is the last known working kernel for you, and 38 breaks, that's
a lot of commits (about 10k, to be exact), and it will take an
annoying number of reboots and tests, but assuming you don't hit any
problems, it should still be "only" about 14 bisection points or so.

You could *try* to minimize the bisect by only looking at commits that
change mm/, but quite frankly, partial tree bisects tend to not be all
that reliable. But if you want to try, you could do basically

   git bisect start mm/
   git bisect good v2.6.37
   git bisect bad v2.6.38

and go from there. That will try to do a more specific bisect, and you
should have fewer test points, but the end result really is much less
reliable. But it might help narrow things down a bit.

             Linus
