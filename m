Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1JSQV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:21:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36649 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844Ab1JSQVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:21:23 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <20111019161537.GH15908@one.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <20111016033514.GC26654@one.firstfloor.org>
	 <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
	 <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org>
	 <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com>
	 <20111019161537.GH15908@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 11:21:21 -0500
Message-ID: <1319041281.3034.25.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 18:15 +0200, Andi Kleen wrote:
> On Wed, Oct 19, 2011 at 10:54:23AM -0500, James Bottomley wrote:
> > 
> > > One alternative to track it down would be to apply the attached
> > > patch to the gcc, then gcc would print it out.
> > 
> > I think the basic problem that excites the toolchain somehow is
> > sectional annotations.  Can't we just dump them and do it all in a
> 
> We already use these annotations all over. Just currently they mess up
> the 'r' and 'w' bits on the sections because a few (not the majority)
> of declarations mismatch the ro vs rw sections.  My patchkit was just trying
> to fix up those that were wrong
> 
> So you should be already using them.
> 
> Just need to find out what triggers your toolchain with these changes.
> I suspect it's some kind of toolchain bug.

I think I've already said 3 times that I think it's some kind of
toolchain bug.  The problem is it's likely in all the non-x86
toolchains.

> > linker script?  Linker scripts seem to be much better tested.
> 
> The linker script just declares the order of the section. 
> The attributes are a union of what the compiler declares.
> To dump them I just use objdump --section-headers or
> readelf -a usually.

OK, look at it another way: why do we need the type annotations?  I
think it's only for section conflict checking, right?  If the compiler
gets it wrong anyway, why not just dump all the type annotations, then
it should have no type conflicts (spurious or otherwise) to complain
about.  We already have link time section checking scripts (they're the
useless ones that complain about section mismatches in dev annoations)
so why not put them to work to make up for compiler deficiencies?

James


