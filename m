Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1CYRec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:34:32 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:60843 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751088Ab1CYReb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:34:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BaR0Igsj1z3eoqhQzbrkz03FrclpoP2MHJQxHskd8B5fplyTEl2wB6XQK//NiC9PGu94bc0nOOSOKnt7Lr9diJWzY847vopZVd1Kfjf0ykEW8vAgaS0FNrblc/kQNzEf;
Date: Fri, 25 Mar 2011 10:34:25 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Ben Skeggs <skeggsb@gmail.com>,
        Michel =?ISO-8859-1?B?RORuemVy?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20110325103425.11c05315@jbarnes-desktop>
In-Reply-To: <AANLkTik4JbopDbdqrSAbontJmYcDeXcbGf=Ah0deo=P9@mail.gmail.com>
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
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011 10:01:14 -0400
Jerome Glisse <j.glisse@gmail.com> wrote:

> On Fri, Mar 25, 2011 at 6:25 AM, Ben Skeggs <skeggsb@gmail.com> wrote:
> > Oh, I wish this were actually the case.  The last time we attempted such a thing we were blasted by Linus.  It does make me wonder at why we're even bothering being in staging.
> >
> > This is where the binary drivers have a huge advantage, they package all the pieces of their driver together and can modify things as necessary.
> >
> > Part of me does think such an approach with the open source graphics drivers would be better.  The current model doesn't really fit too well in my opinion.  Though, admittedly, there's different problems to going other ways.
> >
> > Ben.
> 
> Well i think being able to evolve the API would help a lot, it should
> still be possible to keep supporting old API over a year or so. But my
> feeling is some of the current API for some of the device, needs heavy
> lifting if we ever want to improve things.

Going back to the old model of a separate drm repo would create more
problems than it solves, IMO.

One thing I think Linus has been fairly consistent about is that making
things easy for users (well at least power users who build their own
kernels) is important.  That means ABIs need to be stable so that their
existing userspace continues to work even after a kernel upgrade.

If we went back to the old, out of tree model, we might be able to
break things more easily (i.e. require lockstep upgrades of kernel &
userspace when we change things, hopefully for a good reason), but I
think end users would end up suffering.  They'd have to rely on their
distro to pick up such changes and make sure dependencies were met and
that upgrades/downgrades worked properly across the pre-packaged
kernels that they made available.

One of the main reasons we moved in-tree was to make sure our bits got
into the hands of users more quickly, and to make life easier for the
various downstream distros, not all of which have deep expertise in the
graphics stack.

Fortunately, neither of the issues that started this thread, the
suspend/resume regression in i915 and the vblank ioctl enhancement, are
problems in this respect.  The former is just a bug (though definitely
not one that should have made it to Linus's tree) and the latter does
preserve compatibility and fix a major issue, so isn't really a problem
imo.

But in the general sense, I think we just have to bite the bullet, take
our time with ABI additions and changes so as to preserve compatibility
for a long time (I think we've been doing well with this on the Intel
side at least; we add feature flags every time we change something, and
make sure userspace is forward and backward compatible).  This is more
work for us, but I think it benefits the user in the end.  And it could
be worse, at least we're not still dealing with memory layout
compatibility between the DRM, fbdev, DDX and DRI drivers anymore!

-- 
Jesse Barnes, Intel Open Source Technology Center
