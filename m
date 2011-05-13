Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab1EMSzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:55:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34979 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1EMSzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=P1AguGsWLA6a2XeVlojE8LT7ZuF+A28mmdRNxwBez2eiBo1YcaEt365dCrACcw4uzQ
         TXe0mg9aOZDvNUlAgc/gbzqwK3zixA36MhID20UjLsu3oxESPoaHOr7LGK/RxEyTSHjp
         kOp6DcW0AvOAN9+88QY1B0l75Rn5EG3WW8Xxo=
MIME-Version: 1.0
In-Reply-To: <7vliya77xl.fsf@alter.siamese.dyndns.org>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
 <BANLkTikMeyRTOB9q4PEAYWnZRZfk3wg=kQ@mail.gmail.com> <BANLkTi=dL+KyQ3Bm58_Uj4LP9WSpbzAfJA@mail.gmail.com>
 <BANLkTi=NdVUUZ=_bACzyeMGS3JWs0EMbWA@mail.gmail.com> <BANLkTimE2GkkhcFZtNrYZASWp0LDhUx=GQ@mail.gmail.com>
 <BANLkTinyzBnksHk_rt8K2pmg90q5WyZX3w@mail.gmail.com> <BANLkTinVT=9+-HhwXcyLBwrnhX9F9Qz3ww@mail.gmail.com>
 <4DCD79A0.7000500@kdbg.org> <BANLkTi=smoaARKyzWxFjid-E7qehmyAX8w@mail.gmail.com>
 <7vliya77xl.fsf@alter.siamese.dyndns.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 13 May 2011 14:55:03 -0400
X-Google-Sender-Auth: E-KDphPh0SXJPp5rjtGcrYpWuac
Message-ID: <BANLkTi=dFhxWHHPiYi6P7Mn45J7dZXn=AQ@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
To: Junio C Hamano <gitster@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Sixt <j6t@kdbg.org>,
        Christian Couder <christian.couder@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        git@vger.kernel.org, Shuang He <shuang.he@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 2:48 PM, Junio C Hamano <gitster@pobox.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> When you say that v2.6.38 is good, that means that everything that can
>> be reached from 2.6.38 is good.
>>
>> NOT AT ALL the same thing as "git bisect requires v2.6.38" would be.
>>
>> The "requires v2.6.38" would basically say that anything that doesn't
>> contain v2.6.38 is "off-limits". It's fine to call them "good", but
>> that's not the same thing as "git bisect good v2.6.38".
>>
>> Why?
>>
>> Think about it. It's the "reachable from v2.6.38" vs "cannot reach
>> v2.6.38" difference. That's a HUGE difference.
>
> Could you please clarify "off-limits"?
>
> Do you mean "anything before v2.6.38 did not even have this feature, so
> the result of testing a version in that range does not give us any
> information"?  The feature didn't even exist, so a bug can never trigger,
> and seeing "good" from such a version does not mean everything reachable
> from it is good?  Upon seeing "bad" result from a version before v2.6.38,
> what can we conclude?  The breakage cannot possibly come from the feature
> that is being checked, so the procedure to check itself is busted?
>

In my case, if I'd given bisect a hint that commits that don't include
v2.6.38 are unlikely to work for reasons unrelated to the bug, then
there should still have been enough revisions left for bisect to tell
me "the bug was introduced by the merge of the drm tree but I can't
tell you more without testing off-limits revisions".  That would have
avoided testing three or four revisions that just failed to boot.

In my particular case I think it would also have avoided an
unnecessary set of tests to figure out why the networking merge broke
my system when the networking merge did not, in fact, break my system.
 This is coincidence -- all of the commits that didn't have the change
that fixed the bug the first time around also didn't contain v2.6.38,
so I never would have tested them.

This is maybe some further justification for a bisect mode that
follows the --first-parent path as long as possible -- it might take
one or two more kernel builds, but it avoids odd trips around the
history that can hit random crap like that.  (Of course, it could lead
to different random crap, but what can you do?)

--Andy

--Andy

>
>
