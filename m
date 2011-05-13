Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab1EMQL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:11:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab1EMQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:11:55 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=NdVUUZ=_bACzyeMGS3JWs0EMbWA@mail.gmail.com>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
 <BANLkTikMeyRTOB9q4PEAYWnZRZfk3wg=kQ@mail.gmail.com> <BANLkTi=dL+KyQ3Bm58_Uj4LP9WSpbzAfJA@mail.gmail.com>
 <BANLkTi=NdVUUZ=_bACzyeMGS3JWs0EMbWA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 May 2011 09:11:31 -0700
Message-ID: <BANLkTimE2GkkhcFZtNrYZASWp0LDhUx=GQ@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
To: Andrew Lutomirski <luto@mit.edu>
Cc: Christian Couder <christian.couder@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        git@vger.kernel.org, Shuang He <shuang.he@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 7:56 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> So what I really want is a fancy version of git bisect that makes no
> assumptions about the relationship of good and bad commits in the
> graph and just finds me a commit that is bad but for which all parents
> are good or vice versa.

Ehh. That's the "non-fancy" way of testing, I'm afraid: if you cannot
make assumption about the relationship between good and bad commits,
then you have to test _every_ commit.

So yes, bisection has its problems. But they really do come from the
fact that it's very efficient. When you have (on average) about ten
thousand commits between releases, you have to make assumptions about
the relationships. But once you do that, the efficiency also results
in a certain fragility.

Think of it as a compression method: it generates the smallest
possible set of test points for you. But it's a "lossy" compression -
you don't test everything. And it's extreme: it boils down 10k commit
events to about 13 bisection events. If anything goes wrong (like the
bug not being entirely repeatable, or the bug comes and goes), it will
give the wrong answer.

The good news is that _usually_ it works really well. And when the
choice is between "works really well for 10k commits but can have
problems" and "you need to test all 10k commits", the "can have
problems" part turns out to be a pretty small downside ;)

                                Linus
