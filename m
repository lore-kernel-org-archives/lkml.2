Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab1CYHVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:21:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38020 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab1CYHVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e5EHORl8F/AEg9nBkPsCEDlqhfwhQQHBJ7Fekhqpp51sEtz1xpIKc/Gsg8S01lADNS
         R723ubn22fA4LyvQX6UCIR+Yb/Zy+8254AawJE2mei3Juzn0guaAbjeZxmnAaMZSqxat
         b8ksEHFZI/zZu10DGCiJ4HYpKj+EXyD0bsUlM=
MIME-Version: 1.0
In-Reply-To: <AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
	<AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	<1300868532.3522.81.camel@thor.local>
	<AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
	<Pine.GSO.4.62.1103230633160.12612@umail>
	<1300880747.16522.13.camel@thor.local>
	<AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
	<Pine.GSO.4.62.1103240628490.1156@umail>
	<AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
	<AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
	<AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com>
	<AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
	<AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
Date: Fri, 25 Mar 2011 17:21:21 +1000
Message-ID: <AANLkTim4jYfAFHkaHAWRU2uAzgRJLP1p1=5dugZgYkhS@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 10:17 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 24, 2011 at 5:07 PM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> Like seriously you really think VFS locking rework wasn't under
>> development or discussion when you merged it? I'm sure Al would have
>> something to say about it considering the number of times he cursed in
>> irc about that code after you merged it.
>
> Umm. That code was basically over a year old by the time it was merged.
>
> How old was the code we're talking about now? Seriously?

It was 30 lines of clean code, that really was fine to be merged in
its first form it was merely a future maintaince issue to clean up the
interface before it was released as stable.

> And your argument that this case is something you'd have pushed even
> outside the merge window - I think that sounds like more of the same
> problem. You say it fixes a problem - but does it fix a REGRESSION?
>
> Do you see the difference? Every single commit I get "fixes a
> problem". But our rules for these things are much stricter than that.

Okay I'll explain something from my position and maybe you'll never
want to pull from me again, but the kernel release cycle doesn't work
at all well for graphics drivers.

Why?

well the major fail case we have is my monitor doesn't switch on. Now
if I merge new hardware support for a new GPU in 2.6.38, and sometime
in 2.6.39-rc1 we come across a variant that is broken (this happens
every kernel, we find at least 5 GPU variants or BIOS table reports on
radeon, look at pretty much any post -rc1 patch from Alex Deucher).
Now by your rules this isn't a regression, but now for a user to
actually get this change in their hands I have to wait until
2.6.40-rc1, and only once its in your tree, maybe it can go to stable.
This is 6 months later. That is to pardon my french, fucking
shithouse. I have to make judgement calls on a lot of patches on
whether they are suitable or not to go upstream and I try to think
that the sooner the poor bastard stuck with this hardware can get this
fix then the better it is for everyone, regression or not.

In this case, if you had a >2 monitor setup connected to an evergreen
card, and you tried to do 3D on the 3rd monitor it would just hang the
app in a loop forever, the fix needs 3 pieces, one in the kernel, and
two userspace fixes. I can have the userspace fixes on users disks in
under a week, literally. We release a new libdrm/-ati driver and
distros will have it available in hours via rawhide or xorg-edgers in
Ubuntu. Now under kernel rules you want me to hold it up for 6 months?
just because it was a few days later for the merge window. Why 6
months? because a distro won't ship it until 2.6.40 is released.

Another example is most of Marek's patches where he enables some
userspace feature by allowing the kernel to accept new commands to
send to the GPU. Again this is to avoid a 6 month window where nobody
can use this feature of the 3D driver that is on their disk until they
get a kernel upgrade. Despite what you have said before and obviously
think its much easier to get users to update userspace than kernels in
the real world.

This is why I often put things that aren't strict regression fixes in
after -rc1 and accept the same from intel and nouveau. I draw the line
at things like performance enhancements and I should be more strict on
some of the crap that gets past in Intel, but I make a lot more
judgement calls on these things and I often make them wrong, but I'd
rather be making them than just being an ass to people who are stuck
in vesa mode and can't suspend/resume because their GPU just shows a
black screen on startup on new hw or they can't get acceleration
support for 4 months.

I'm also aware we never get enough testing coverage before stuff hits
your tree, we'd need 1000s of testers to run drm-next and we just
don't have that variation. So yes when new features hit -rc1 with the
drm they nearly always cause regressions, its just not possible to
test this stuff on every GPU/monitor/bios combination in existance
before we give it to you, that just isn't happening. Like radeon
pageflipping caused machines to completely hang and I didn't find out
until -rc7 due to lack of testing coverage.

I'm seriously contemplating going back to out-of-tree drivers so we
can actually get test coverage before you get things, however that
comes with its own set of completely insane problems.

Its not like I'm not aware of the problems here, I'm very aware, I'm
just clueless on how to provide actual valuable drm code to users in
anything close to a timely manner, people buy new graphics card
quicker than I can get code into the kernel.

Dave.
