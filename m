Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1EUAGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:06:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36768 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab1EUAGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e4WpM2Uo6OV0SqF3pRpTlQa3fT5BVJTPC4SK7QnB1t2burNwVOkRqAGmBOddJw1KeQ
         qyEorm9+oeTl0aj0utGDlIEr7up0Zyx9hcgzFbPY2y4HGmVH6ZZOc5Nzjz5pXmZ3noCk
         UdRlrZD6xfUy76x4yKxJo6r+Si/YGE8IuGmWc=
MIME-Version: 1.0
In-Reply-To: <fc49a1b4c32eee9b5cbfbeec4729eef5@localhost>
References: <1305715384-81716-1-git-send-email-tsunanet@gmail.com>
	<20110518.152653.1486764697527722925.davem@davemloft.net>
	<BANLkTik-6wh8=jb6oMEpJvYC8+KTGGsMsw@mail.gmail.com>
	<20110518.155200.801089483916944725.davem@davemloft.net>
	<20110518202025.GC4175@nuttenaction>
	<BANLkTimtA9BB7g5cOm8c9sGChQjf1P0Q-Q@mail.gmail.com>
	<fc49a1b4c32eee9b5cbfbeec4729eef5@localhost>
Date: Fri, 20 May 2011 17:06:01 -0700
Message-ID: <BANLkTi=p1V1x+y=-cH-Q7bvueu_4_D1ywQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: Expose the initial RTO via a new sysctl.
From: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: David Miller <davem@davemloft.net>, tsunanet@gmail.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Hagen,

On Fri, May 20, 2011 at 4:00 AM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
>
> On Fri, 20 May 2011 03:27:37 -0700, "H.K. Jerry Chu" wrote:
>
> Hi Jerry
>
>> Not sure how our various parameter tuning proposals deviate from the
> "TCP
>> over everything" principle?
>
> For our environment it hurts because we _always_ have an initial RTO >1. I
> understand and accept that 98% will benefit of this modification, no doubt
> Jerry! Try to put yourself in our situation: imaging a proposal of an init

Understood but my point was none of the parameter tuning proposals break
"TCP over everything", although they may not help solving "TCP optimized for
everything", but we never had the latter anyway.

We've tried hard to keep the penalty to those initRTT > 1sec paths at a minimum,
i.e., just one extra tinygram. This is important also for us because it may take
> 1sec for many Android clients to establish connections over a radio channel that
has been put into power saving mode.

> RTO modification to 0.5 seconds. Maybe because 98% of Internet traffic is
> now localized and the RTO is average now 0.2 seconds. Anyway, this will
> penalize your network always and this will be the situation for one of my
> customer. I can live with that, I see the benefits for the rest of the
> world. But I am happy to see a knob where I can restore the old behavior.
> Maybe some other environments will benefit from a even lower or higher
> initial RTO.

Yep, that's why we've had a knob for this for years.

Jerry

>
> Hagen
>
