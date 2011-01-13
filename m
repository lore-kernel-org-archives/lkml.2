Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab1AMVkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:40:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757173Ab1AMVkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:40:41 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1101140826340.27060@tundra.namei.org>
References: <alpine.LRH.2.00.1101101136001.21289@tundra.namei.org>
 <AANLkTinU2mNyTEc55=ypDPXWah_ozaV1BHWBqCenxp1Z@mail.gmail.com>
 <alpine.LRH.2.00.1101110855330.28785@tundra.namei.org> <AANLkTik1kxC_GBKYSvhAK6_O0Bt-ALbEP3T=+AmMQRLP@mail.gmail.com>
 <alpine.LRH.2.00.1101140826340.27060@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 13:39:49 -0800
Message-ID: <AANLkTikDBpw17OwKvhpq3LqPrurCseWrCyw4VQF=xZY4@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 2.6.38
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 1:29 PM, James Morris <jmorris@namei.org> wrote:
>
> The most common cases are to resolve a conflict, or to apply a patch which
> depends on something in your tree, neither of which are really directly
> associated with tags.

So? Seriously. Neither are they "really directly associated with
branch 'linus'". So what's the advantage of picking a random spot, and
not even explaining it?

At least with "Merge tag 'v2.6.37'" or similar, there's some reason to
believe that the spot you picked was meaningful.

The thing is, those back-merges make it much harder to bisect stuff,
and make it much harder to test the things you send me independently -
because the commits don't exist independently, but are tied in to
random daily snapshots. If somebody reports a problem, I can't ask
them to just check the tip commit of the merge, they'll have to test
all the random stuff that went into my tree too.

Right now, for example, depending on your graphics card, you may not
have working X at all. Did you happen to merge one of those trees? I
don't know, and you don't know. So imagine that your tree introduces
some problem, and somebody who happens to have one of those graphics
cards would notice. How does he test?

And if it was _one_ merge, I'd understand. But there's several. Why
would you care about "resolve a conflict" anyway? The conflict doesn't
even _exist_ unless you merge, so merging to resolve a conflict is a
nonsensical notion. And during the merge window, we'd certainly hope
that your code doesn't depend on other peoples code, since that hasn't
been merged yet, and the merge window was for merging code that was
ready _before_ the merge window.

Yes, yes, there can sometimes be real dependencies. It happens. But it
should be rare, and it should be seen as a problem, not a "ok, let's
do several merges".

So the mindset people should have is to avoid back-merges,
_especially_ the "random daily" ones. And if you do them, explain
them.

                    Linus
