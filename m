Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab2DPFjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:39:45 -0400
Received: from 1wt.eu ([62.212.114.60]:65219 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2DPFjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:39:43 -0400
Date: Mon, 16 Apr 2012 07:39:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120416053911.GL27728@1wt.eu>
References: <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com> <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com> <CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com> <CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com> <20120414104733.GA4871@gmail.com> <CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com> <20120415065124.GC29563@gmail.com> <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com> <CA+55aFz8oepgj7W8W=d18qwQt3JUGgv+pCto-_2WS3WJ3ZKqzQ@mail.gmail.com> <CAMP44s2vx5cn_=tRD46SqAobRceLiZDfi9-zLUnv_g89wLxryQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2vx5cn_=tRD46SqAobRceLiZDfi9-zLUnv_g89wLxryQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 01:12:48AM +0300, Felipe Contreras wrote:
> I'm not going to argue the semantics of what is a revert, but I am
> going to show the difference between the two situations:
> 
> a) v3.0* (good), v3.1* (good), v3.2* (good), v3.3 (good), v3.3.1
> (bad), v3.3.2 (good), v3.4 (bad)

This situation is not possible thanks to the process : if v3.3.2 has
a fix that was not in 3.3.1, then this fix is also in 3.4.

> b) v3.0* (bad), v3.1* (bad), v3.2* (bad), v3.3 (bad), v3.3.1 (good), v3.4 (bad)

Same here.

> Maybe they are the same from certain point of view, but you just
> argued that what *others* see is what makes the patch unrevertable,
> well, it's obvious that from the point of view of the users the two
> situations are clearly different. I believe it was you who said that
> breaking user experience is the absolute no-no any project could
> make[1]--so from that point of view a) is *much* worst.
> 
> But what is done is done, and as you said, you can't change the past,
> now the important thing is what to do next. And here are the two
> options' worst-case scenarios:
> 
> a.1) v3.0* (good), ... v3.3 (good), v3.3.1 (bad), v3.3.2 (bad), v3.3.3
> (bad), v3.3.4 (bad), v3.3.5 (bad), v3.4 (good)

This situation is stupid as it means we'd refuse to fix the issue.

> a.2) v3.0* (good), ... v3.3 (good), v3.3.1 (bad), v3.3.2 (good),
> v3.3.3 (good), v3.3.4 (good), v3.3.5 (good), v3.4 (bad)

Not possible.

> These two scenarios are unlikely, but either way, in order to
> guarantee that you don't end up with a.2) You are willing to risk
> going into a.1)

You don't seem to understand that 3.4 is not *after* 3.3.x, but in parallel.
This is more like this :

  3.2 ----- 3.3 --------- 3.4-rc* ------------- 3.4 ----- 3.5-rc* --------
               \                                    \
                \                                    `--- 3.4.1 ---- 3.4.2 --
                 \
                  `--- 3.3.1 ----- 3.3.2 ---- 3.3.3 ---- 3.3.4 --- 3.3.5 ---

Here you clearly see why everything in 3.3.x must come from upstream and
why it's important that 3.4 has every fix that 3.3 has.

> So, *obviously* v3.4 is more important than v3.3.x. I could argue that
> the users out there would prefer a.1) any day, because it's unlikely
> anyway (v3.4 would be good), but I won't.

No because for them it would mean end of support at one point when 3.3 dies,
with no ability to upgrade.

> All I want now is to agree on a reason, you have finally pointed out
> that the reason for this different treatment is the user's visibility,

It's not the user's visibility, it's published code. Once code is published,
you cannot magically fix it without emitting a new patch for this code and
announcing so that users apply it. These patches are called stable releases.
Users want a good reason to apply these patches, rebuild and reboot, and
that's one reason we absolutely want to have the commit descriptions from
upstream which detail the exact reason for the patch (even if it's a revert).

> but that still doesn't explain why the rules for b) automatically
> apply to a), since it's clearly different from the users's point of
> view; if you agree that v3.4 is more important than v3.3.x, I believe
> we have the reason right there.

It's not "more important", it's important for long-term stability. For
3.3 users, 3.3.x is more important that 3.4. However one thing is certain:
3.4 users are not going to push fixes into 3.3.x, but thanks to the process
we have, 3.3.x users are going to ask for a fix to be pushed upstream. So
users pressure ensure long-term stability.

Willy

