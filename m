Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1EMSml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:42:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061Ab1EMSmj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:42:39 -0400
MIME-Version: 1.0
In-Reply-To: <4DCD79A0.7000500@kdbg.org>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
 <BANLkTikMeyRTOB9q4PEAYWnZRZfk3wg=kQ@mail.gmail.com> <BANLkTi=dL+KyQ3Bm58_Uj4LP9WSpbzAfJA@mail.gmail.com>
 <BANLkTi=NdVUUZ=_bACzyeMGS3JWs0EMbWA@mail.gmail.com> <BANLkTimE2GkkhcFZtNrYZASWp0LDhUx=GQ@mail.gmail.com>
 <BANLkTinyzBnksHk_rt8K2pmg90q5WyZX3w@mail.gmail.com> <BANLkTinVT=9+-HhwXcyLBwrnhX9F9Qz3ww@mail.gmail.com>
 <4DCD79A0.7000500@kdbg.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 May 2011 11:41:46 -0700
Message-ID: <BANLkTi=smoaARKyzWxFjid-E7qehmyAX8w@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
To: Johannes Sixt <j6t@kdbg.org>
Cc: Andrew Lutomirski <luto@mit.edu>,
        Christian Couder <christian.couder@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        git@vger.kernel.org, Shuang He <shuang.he@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:34 AM, Johannes Sixt <j6t@kdbg.org> wrote:
> Am 13.05.2011 19:54, schrieb Linus Torvalds:
>> For example, in your case, since you had certain requirements of
>> support that simply didn't exist earlier, something like
>>
>>    git bisect requires v2.6.38
>>
>> would have been really useful - telling git bisect that any commit
>> that cannot reach that required commit is not even worth testing.
>
> You can already have this with
>
>   git bisect good v2.6.38
>
> It sounds a bit unintuitive, but with a slight mind-twist it can even be
> regarded as correct in a mathematical sense: when the precondition is
> false, the result is true. ;-)

No. That's not the same thing AT ALL.

When you say that v2.6.38 is good, that means that everything that can
be reached from 2.6.38 is good.

NOT AT ALL the same thing as "git bisect requires v2.6.38" would be.

The "requires v2.6.38" would basically say that anything that doesn't
contain v2.6.38 is "off-limits". It's fine to call them "good", but
that's not the same thing as "git bisect good v2.6.38".

Why?

Think about it. It's the "reachable from v2.6.38" vs "cannot reach
v2.6.38" difference. That's a HUGE difference.

                       Linus
