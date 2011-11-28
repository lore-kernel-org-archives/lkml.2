Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1K1OFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:05:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42704 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1OFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:05:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111129005341.c5caf7f353876a0dd4764d3c@canb.auug.org.au>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
	<CAPM=9twsvX=hFS9S01-ht8JHhAAy4uP8N5NxPUDY9UpbsvQWmw@mail.gmail.com>
	<20111128135317.a99880b234c6c060a622fa31@canb.auug.org.au>
	<20111128113056.2099e4c3@lxorguk.ukuu.org.uk>
	<20111129001353.399142710ab77822b29552f0@canb.auug.org.au>
	<20111128131847.48bffb93@lxorguk.ukuu.org.uk>
	<20111129005341.c5caf7f353876a0dd4764d3c@canb.auug.org.au>
Date: Mon, 28 Nov 2011 14:05:13 +0000
Message-ID: <CAPM=9ty_SRGsGaRyDAZbXcdaLXOTapZ2v4J6hyBArfntA8HqDA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drm tree
From: Dave Airlie <airlied@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 1:53 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Alan,
>
> On Mon, 28 Nov 2011 13:18:47 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>
>> > > Well its very hard to sort stuff out when you are juggling a cross tree
>> > > set of dependancies and someone pointlessly stops one of them being
>> > > visible in next for ten days.
>> >
>> > The mess in the drm tree has nothing to do with the staging tree.
>>
>> I would suggest you re-read the paragraph above, and the mails I sent you
>> about marking the staging gma500 tree broken (which given nothing
>> happened in response to any of them I imagine you didn't).
>
> When I originally reported this problem, you responded:
>
>> gma500 is frozen pending Dave Airlie's applying the patches moving it out
>> of staging.
>>
>> <Prod, prod>
>
> Which I assumed was aimed at Dave.  Then Jesse (whose changes broke the
> code in staging) responded with a patch which I assumed that Dave would
> do something with.  Then the next day you responded with:
>
>> If the staging gma500 is causing this still please resolve it by marking
>> the GMA500 in staging "&& BROKEN" for the moment.
>
> And maybe I should have done something then.  I fall back on the excuse
> that I have about 200 trees to merge every day and when I use to fix
> things for people I used to have lots of 12-16 hour days ...
>
>> And if you still think that blocking the DRM tree from -next for ten days
>> thus stopping all sorts of other integration work and forcing people's
>> hands on moving from staging and the like didn't cause the problems and
>> is the right policy then we'll just have to agree to differ.
>
> If you are trying to get something merged into the drm tree, you should
> be working with the drm tree and with the drm maintainer, not
> linux-next.  Linux-next is here to find integration problems between
> trees and across architectures not to find problems with changes within
> one tree.
>
> And I repeat, the breakage today is nothing to do with the staging tree,
> it is in the drm tree and how your gma500 changes were merged there (and
> to be clear, there is nothing wrong with the gma500 changes per se).
>
> In the future, I will try to remember to "kill staging first", but this
> is the first time it has come up since staging started being built by an
> allmodconfig build (which it used not to be - and that change was not my
> choice).

Yeah I've tracked it down here, I had messed up the configs locally so
Alan's code wasn't built, I'll pile some fixes on top of it today.

Dave.
