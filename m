Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1CYSJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:09:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47043 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1CYSJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FiO5wxzJiafzfBgEy+jAzHmD8Njwx1KurITuh+8xbPpZDRonoB1du1sgpnI0VJV3FG
         uYpHi9wBTVXMJ/OaujWIZaTGwzVIqP87EsAHEI5IEpETVCHh9OumEFxMffvlnQe8oWo9
         JP0FzQ41eYDOPUPYmcF3aCuuIZsNyh4t+4IuE=
MIME-Version: 1.0
In-Reply-To: <20110325103425.11c05315@jbarnes-desktop>
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
	<AANLkTi=pKTAcbe9x62pQu6dkDFX=zO9r4b_6T0Uo-ay7@mail.gmail.com>
	<9C992DD6-02C7-437C-B78B-13A4282E9AE3@gmail.com>
	<AANLkTik4JbopDbdqrSAbontJmYcDeXcbGf=Ah0deo=P9@mail.gmail.com>
	<20110325103425.11c05315@jbarnes-desktop>
Date: Fri, 25 Mar 2011 14:09:52 -0400
Message-ID: <AANLkTi=s=79JXvFiB4GkorW08702NRjkp9KCuCqFHjN=@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Jerome Glisse <j.glisse@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ben Skeggs <skeggsb@gmail.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 1:34 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 25 Mar 2011 10:01:14 -0400
> Jerome Glisse <j.glisse@gmail.com> wrote:
>
>> On Fri, Mar 25, 2011 at 6:25 AM, Ben Skeggs <skeggsb@gmail.com> wrote:
>> > Oh, I wish this were actually the case.  The last time we attempted such a thing we were blasted by Linus.  It does make me wonder at why we're even bothering being in staging.
>> >
>> > This is where the binary drivers have a huge advantage, they package all the pieces of their driver together and can modify things as necessary.
>> >
>> > Part of me does think such an approach with the open source graphics drivers would be better.  The current model doesn't really fit too well in my opinion.  Though, admittedly, there's different problems to going other ways.
>> >
>> > Ben.
>>
>> Well i think being able to evolve the API would help a lot, it should
>> still be possible to keep supporting old API over a year or so. But my
>> feeling is some of the current API for some of the device, needs heavy
>> lifting if we ever want to improve things.
>
> Going back to the old model of a separate drm repo would create more
> problems than it solves, IMO.
>
> One thing I think Linus has been fairly consistent about is that making
> things easy for users (well at least power users who build their own
> kernels) is important.  That means ABIs need to be stable so that their
> existing userspace continues to work even after a kernel upgrade.
>
> If we went back to the old, out of tree model, we might be able to
> break things more easily (i.e. require lockstep upgrades of kernel &
> userspace when we change things, hopefully for a good reason), but I
> think end users would end up suffering.  They'd have to rely on their
> distro to pick up such changes and make sure dependencies were met and
> that upgrades/downgrades worked properly across the pre-packaged
> kernels that they made available.
>
> One of the main reasons we moved in-tree was to make sure our bits got
> into the hands of users more quickly, and to make life easier for the
> various downstream distros, not all of which have deep expertise in the
> graphics stack.
>
> Fortunately, neither of the issues that started this thread, the
> suspend/resume regression in i915 and the vblank ioctl enhancement, are
> problems in this respect.  The former is just a bug (though definitely
> not one that should have made it to Linus's tree) and the latter does
> preserve compatibility and fix a major issue, so isn't really a problem
> imo.
>
> But in the general sense, I think we just have to bite the bullet, take
> our time with ABI additions and changes so as to preserve compatibility
> for a long time (I think we've been doing well with this on the Intel
> side at least; we add feature flags every time we change something, and
> make sure userspace is forward and backward compatible).  This is more
> work for us, but I think it benefits the user in the end.  And it could
> be worse, at least we're not still dealing with memory layout
> compatibility between the DRM, fbdev, DDX and DRI drivers anymore!
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>

While for small change, slowly evolving the API is doable in backward
compatible way, major change are not. For instance if i were to write
radeon kms today i would drop the domain stuff out of the mix, would
not do the command submission the way they are and bunch of others
things that i have been meaning to try but have yet to prototype.
Change i am thinking about here means different userspace which would
communicate with kernel in a completely different way.

I am just acknowledging the fact that i did a bunch of very poor
decision in radeon kms and i feel that today i know better what would
be a good API but i can be wrong once again.

That aside, i would prefer if we stay upstream but if moving in our
own repo allow us to break API then i would jump in right away.

Note that when changing API one could keep old API with old code
around and just refuse to fix any issue with the old one, that means
some one updating kernel with something that worked will still have a
working configuration. If he then want to improve its graphics
experience he would have to update the userspace bits.

Cheers,
Jerome
