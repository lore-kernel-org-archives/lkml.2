Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1IBQxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:53:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44242 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1IBQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:53:47 -0400
Date: Fri, 2 Sep 2011 18:53:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: ARM assembly syntax  (was Re: [patch 03/36] Hexagon: Add
	bitops support)
Message-ID: <20110902165345.GA27018@atrey.karlin.mff.cuni.cz>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.145693358@codeaurora.org> <20110826203410.GB6630@ucw.cz> <20110830211449.GC7047@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830211449.GC7047@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Aug 26, 2011 at 10:34:10PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > +	__asm__ __volatile__ (
> > > +	"	{R10 = %1; R11 = asr(%2,#5); }\n"
> > > +	"	{R10 += asl(R11,#2); R11 = and(%2,#0x1f)}\n"
> > > +	"1:	R12 = memw_locked(R10);\n"
> > > +	"	{ P0 = tstbit(R12,R11); R12 = clrbit(R12,R11); }\n"
> > > +	"	memw_locked(R10,P1) = R12;\n"
> > > +	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
> > 
> > Nice assembly syntax, btw. I can only wish architectures such as arm
> > used something as readable...
> 
> Yes, I, too, was very pleasantly surprised when I first saw this.

> Of course, one *could* alter binutils to accept something similar
> for ARM, and then alter gcc to spit it out. Whether anyone would use

Well, it would be enough if binutils accepted this; making gcc
generate it is optional. It would be mostly used for inline assembly etc...

> this isn't clear .. and I can already almost hear certain maintainers
> telling us how much of a bad idea this is from the maintainership
> point-of-view ....

Well, on x86, we already have at&t and intel assembly syntax. Having
one that was readable would be bonus :-).

[I don't expect anyone to _write_ assembly for unknown processor; but
being able to _read_ unfamiliar assembly would be already huge step
forward.]

And yes, I did notice it is VLIW. Those {} make it pretty obvious.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
