Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0K2J61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:58:27 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57454
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab0K2J6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:58:25 -0500
X-IronPort-AV: E=Sophos;i="4.59,275,1288566000"; 
   d="scan'208";a="68229811"
Date: Mon, 29 Nov 2010 10:58:23 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Microcai <microcai@fedoraproject.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101129095823.GQ5142@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Microcai <microcai@fedoraproject.org>, Ted Ts'o <tytso@mit.edu>,
	Lisa Milne <lisa@ltmnet.com>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu> <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <20101129020610.7ea7c79e.lisa@ltmnet.com> <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org> <1290993244.877.3.camel@cai.gentoo> <20101129085829.GM5142@const.bordeaux.inria.fr> <1291023157.9785.2.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291023157.9785.2.camel@cai.gentoo>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcai, le Mon 29 Nov 2010 17:32:37 +0800, a écrit :
> 在 2010-11-29一的 09:58 +0100，Samuel Thibault写道：
> > Microcai, le Mon 29 Nov 2010 09:14:04 +0800, a écrit :
> > > Hey, my old patch already did it , and do not break any old stuff.
> > 
> > To your knowledge.  IIRC while reading your patch I found a couple of
> > things that would most probably break some corner cases, which could
> > go unnoticed, that's why I proposed to first extend the internal vc
> > content matrix into unicode values, so as to clearly have to upgrade all
> > drivers.
> 
> I doesn't matter *how to do* .

Concerning breaking existing stuff, yes, it does.

> I have many different kinds of patchs that did it in different ways.
> 
> What realy matters is that, do we agree that add unicode font support is
> acceptable ?

Simple unicode font (i.e. just go beyond the arbitrary historical-vga
512 glyphs limit for fbcon) might go in.  Double-width is questionable,
but it can probably simple enough to be able to get in (there is already
some code for it anyway).

But complete unicode support (with arabic ligatures, tibetan
combinations, etc.) won't ever be accepted in the kernel as that's far
too involved in terms of font rendering.  So the userland way needs to
be fixed for these anyway, and then things like chinese will go along...

Samuel
