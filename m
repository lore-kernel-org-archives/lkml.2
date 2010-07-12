Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0GLR24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:28:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35911 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0GLR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:28:49 -0400
Date: Mon, 12 Jul 2010 19:28:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Modpost error after changing CONFIG_SOUND from m to y
Message-ID: <20100712172847.GA17423@merkur.ravnborg.org>
References: <201007120554.16459.vda.linux@googlemail.com> <20100712100301.db1d3980.randy.dunlap@oracle.com> <AANLkTin88f83UV4HcqKtaXS7F2hMTe8YVJPpE-XLmo5J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin88f83UV4HcqKtaXS7F2hMTe8YVJPpE-XLmo5J@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 07:11:47PM +0200, Denys Vlasenko wrote:
> On Mon, Jul 12, 2010 at 7:03 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Mon, 12 Jul 2010 05:54:16 +0200 Denys Vlasenko wrote:
> >> I was using the same .config for my home machine for a long time,
> >> updating it using "make oldconfig" every time I moved to newer kernel.
> >> It worked fine for many kernels.
> >>
> >> In this .config I had CONFIG_SOUND=m.
> >>
> >> Starting witn 2.6.34, build fails with
> >>
> >> sound/core/sound_oss.c:25:2: error: #error "Enable the OSS soundcore multiplexer (CONFIG_SOUND) in the kernel."
> >>
> >> Ok. I changed CONFIG_SOUND to y. Now the build fails at modpost:
> >
> > Hi,
> > I can't get the build to fail (2.6.34 or 2.6.35-rc4-git4).
> > Please provide a full/complete .config file (and that will include a
> > kernel version number :).
> 
> I found out that build only fails if I give empty CFLAGS_KERNEL
> and CFLAGS_MODULE variables to make, like this:
> 
> make CFLAGS_KERNEL="" CFLAGS_MODULE=""

Messing around with kernel internal flags is bound to give
unpredictable bugs.

I this case you loose "-DMODULE" and I guess some sound specificmodules
test on this symbol.
And there may be other subtle side-effects.

What is the intial reason why you assign CFLAGS_KERNEL and CFLAGS_MODULE?

	Sam
