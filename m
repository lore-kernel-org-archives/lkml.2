Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2DOWMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:12:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49484 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2DOWMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFz8oepgj7W8W=d18qwQt3JUGgv+pCto-_2WS3WJ3ZKqzQ@mail.gmail.com>
References: <20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
	<CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
	<CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
	<CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
	<CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
	<CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com>
	<20120414104733.GA4871@gmail.com>
	<CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com>
	<20120415065124.GC29563@gmail.com>
	<CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
	<CA+55aFz8oepgj7W8W=d18qwQt3JUGgv+pCto-_2WS3WJ3ZKqzQ@mail.gmail.com>
Date: Mon, 16 Apr 2012 01:12:48 +0300
Message-ID: <CAMP44s2vx5cn_=tRD46SqAobRceLiZDfi9-zLUnv_g89wLxryQ@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 8:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Apr 15, 2012 at 10:15 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>
>> This is not a reason, this is just stating what happens without
>> explaining *why*.
>>
>> Q: What changes when a tag is made?
>> A: A tag is made

[...]

> The only thing that matters is "it's been made available to others".

Exactly! Now *this* is a reason. After sending that mail I tried to
think of one since nobody else came up with it. This is in fact, a
good reason, but it implies something I'll explain below.

[...]

I do agree with all what you said above.

> And the thing is, it's not just 3.3.3 that follows 3.3.2. It's 3.4.1
> too. The reason we have the "no stable fixes before it's been
> upstreamed" (and again: a "revert" is *nothing* but another name for a
> fix, that gives some additional information about *how* we fixed
> something too) is because we want to make nice plodding reliable
> forward progress. Mistakes (== bugs) will happen, but the stable rules
> are there to make sure that those mistakes get fixed, and don't have
> long-term impact. THAT is the "stable" part of the stable series.
> Things are monotonic in the big picture, even if we may have some
> non-monotonic noise in the details.

I'm not going to argue the semantics of what is a revert, but I am
going to show the difference between the two situations:

a) v3.0* (good), v3.1* (good), v3.2* (good), v3.3 (good), v3.3.1
(bad), v3.3.2 (good), v3.4 (bad)
b) v3.0* (bad), v3.1* (bad), v3.2* (bad), v3.3 (bad), v3.3.1 (good), v3.4 (bad)

Maybe they are the same from certain point of view, but you just
argued that what *others* see is what makes the patch unrevertable,
well, it's obvious that from the point of view of the users the two
situations are clearly different. I believe it was you who said that
breaking user experience is the absolute no-no any project could
make[1]--so from that point of view a) is *much* worst.

But what is done is done, and as you said, you can't change the past,
now the important thing is what to do next. And here are the two
options' worst-case scenarios:

a.1) v3.0* (good), ... v3.3 (good), v3.3.1 (bad), v3.3.2 (bad), v3.3.3
(bad), v3.3.4 (bad), v3.3.5 (bad), v3.4 (good)
a.2) v3.0* (good), ... v3.3 (good), v3.3.1 (bad), v3.3.2 (good),
v3.3.3 (good), v3.3.4 (good), v3.3.5 (good), v3.4 (bad)

These two scenarios are unlikely, but either way, in order to
guarantee that you don't end up with a.2) You are willing to risk
going into a.1)

So, *obviously* v3.4 is more important than v3.3.x. I could argue that
the users out there would prefer a.1) any day, because it's unlikely
anyway (v3.4 would be good), but I won't.

All I want now is to agree on a reason, you have finally pointed out
that the reason for this different treatment is the user's visibility,
but that still doesn't explain why the rules for b) automatically
apply to a), since it's clearly different from the users's point of
view; if you agree that v3.4 is more important than v3.3.x, I believe
we have the reason right there.

Cheers.

[1] http://www.youtube.com/watch?v=kzKzUBLEzwk

-- 
Felipe Contreras
