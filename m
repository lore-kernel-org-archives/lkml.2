Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1JSPy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:54:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36487 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab1JSPy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:54:26 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <20111016033514.GC26654@one.firstfloor.org>
	 <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
	 <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 10:54:23 -0500
Message-ID: <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 23:57 +0200, Andi Kleen wrote:
> vate email?
> >
> > OK, so after fixing up that one, the next failure is:
> >
> > drivers/net/fealnx.c:95: error: version causes a section type conflict
> > drivers/net/fealnx.c:1944: error: fealnx_pci_tbl causes a section type
> > conflict
> 
> Hmm, this is weird (just like the other error)
> I wonder if the pa-risc tool chain has some general problems with sections
> 
> On a successful build with the same config could you send me the output of
> 
> make drivers/net/fealnx.s
> and
> make drivers/net/fealnx.i

> in the same config privately? From that I can see if there's something else
> in init.rodata that does not match my i386 build.

Yes, I'll send under separate cover.

> One alternative to track it down would be to apply the attached
> patch to the gcc, then gcc would print it out.

I think the basic problem that excites the toolchain somehow is
sectional annotations.  Can't we just dump them and do it all in a
linker script?  Linker scripts seem to be much better tested.

James


