Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab1JSQdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:33:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47011 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1JSQdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:33:52 -0400
Date: Wed, 19 Oct 2011 18:33:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Please include const-sections into linux-next
Message-ID: <20111019163351.GJ15908@one.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org> <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com> <20111016033514.GC26654@one.firstfloor.org> <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com> <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org> <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com> <20111019161537.GH15908@one.firstfloor.org> <1319041281.3034.25.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319041281.3034.25.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think I've already said 3 times that I think it's some kind of
> toolchain bug.  The problem is it's likely in all the non-x86
> toolchains.

Not convinced it's everywhere. Just need to track it down.


> 
> > > linker script?  Linker scripts seem to be much better tested.
> > 
> > The linker script just declares the order of the section. 
> > The attributes are a union of what the compiler declares.
> > To dump them I just use objdump --section-headers or
> > readelf -a usually.
> 
> OK, look at it another way: why do we need the type annotations?  I
> think it's only for section conflict checking, right?  If the compiler
> gets it wrong anyway, why not just dump all the type annotations, then
> it should have no type conflicts (spurious or otherwise) to complain
> about.  We already have link time section checking scripts (they're the
> useless ones that complain about section mismatches in dev annoations)
> so why not put them to work to make up for compiler deficiencies?

You mean removing all the init sections stuff?  I think it has been proposed
in the past, but it's a couple of hundred KB of memory usually.
Would you accept that for PA-RISC? 

If you have init sections you need to annotate them correctly because
a section is defined by its rwx attributes plus name and both need
to match. We didn't always check this, so there was some bitrot,
but it ultimatively has to be correct.

-Andi
