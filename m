Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0JET0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:26:43 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:41691 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755137Ab0JET0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:26:41 -0400
Date: Tue, 5 Oct 2010 12:24:35 -0700
From: matt mooney <mfm@muteddisk.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michal Marek <mmarek@suse.cz>, linux-media@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [RFC PATCH] media: consolidation of -I flags
Message-ID: <20101005192435.GA17798@haskell.muteddisk.com>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michal Marek <mmarek@suse.cz>, linux-media@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1285534847-31463-1-git-send-email-mfm@muteddisk.com>
 <20101005142906.GA20059@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005142906.GA20059@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:29 Tue 05 Oct     , Sam Ravnborg wrote:
> On Sun, Sep 26, 2010 at 02:00:47PM -0700, matt mooney wrote:
> > I have been doing cleanup of makefiles, namely replacing the older style
> > compilation flag variables with the newer style. While doing this, I
> > noticed that the majority of drivers in the media subsystem seem to rely
> > on a few core header files:
> > 
> > 	-Idrivers/media/video
> > 	-Idrivers/media/common/tuners
> > 	-Idrivers/media/dvb/dvb-core
> > 	-Idrivers/media/dvb/frontends
> > 
> > This patch removes them from the individual makefiles and puts them in
> > the main makefile under media.
> Using subdir-ccflags-y has one drawback you need to be aware of.
> The variable is _not_ picked up if you build individual drivers like
> this:
> 
> 
>      make drivers/media/dvb/b2c2/
> 
> So with this patch applied it is no longer possible to do so.
> It is better to accept the duplication rather than breaking
> the build of individual drivers.

Ah, I was not aware of that, and I forgot to test for that case.

> > 
> > If neither idea is considered beneficial, I will go ahead and replace
> > the older variables with the newer ones as is.
> 
> This is the right approach.
> 
> You could consider to do a more general cleanup:
> 1) replace EXTRA_CFLAGS with ccflags-y (the one you suggest)
> 2) replace use of <module>-objs with <module>-y
> 3) break continued lines into several assignments
>    People very often uses '\' to break long lines, where a
>    simple += would be much more readable.
>    But this topic may be personal - I never uses "\" in my .c code unless in macros,
>    and I have applied the same rule for Makefiles.
>    An ugly example is drivers/media/Makefile
> 4) In general use ":=" instead of "=".
>    Add using "+=" as first assignment is OK - but it just looks plain wrong
> 5) some files has a mixture of spaces/tabs (are red in my vim)
>    dvb-core/Makefile is one such example
> 6) remove useless stuff
>    siano/Makefile has some strange assignments to EXTRA_CFLAGS
> 7) Likely a few more items to look after...
> 
> This is more work - but then you finish a Makefile rather than doing a simple
> conversion.

I agree with all your points above; however, I was unsure of whether a wholesale
cleanup would be welcomed because I would then end up touching numerous lines
(and in some cases, possibly all lines). I did notice, though, the need for
quite a bit of cleanup like you have mentioned, and I have a few patches queued
up that make a second pass on some files changing <module>-objs to
<module>-y. You know better than I do, so if you feel I should cleanup the whole
file in one patch, then that is what I will do although this will take some
time.

Is the use of <module>-objs deprecated? Some people might wonder why I am
changing that when they are not building a multisource object.

Thanks,
mfm
