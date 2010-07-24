Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0GXKtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:49:24 -0400
Received: from ist.d-labs.de ([213.239.218.44]:56532 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab0GXKtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:49:23 -0400
Date: Sat, 24 Jul 2010 12:49:13 +0200
From: Florian Mickler <florian@mickler.org>
To: trapdoor6@gmail.com, LKML <linux-kernel@vger.kernel.org>
Cc: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: 2.6.35-rc[1-5] + Radeon-kms: 3D graphic performance
Message-ID: <20100724124913.0bbd9a06@schatten.dmk.lab>
In-Reply-To: <AANLkTin1vGdodjhqbckGpVtfScslb7d0KX0h4wPa54Yh@mail.gmail.com>
References: <AANLkTin1vGdodjhqbckGpVtfScslb7d0KX0h4wPa54Yh@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 01:21:24 +0100
trapDoor <trapdoor6@gmail.com> wrote:

> Hi Alex,
> This is with regard to thread 'Blank (disconnected) screen during boot
> with latest 2.6.35-rcX kernels'.
> 
> You asked me in your last e-mail if I could do a bisect to find out
> what caused a regression I mentioned about - in 3D graphic performance
> in kernels 2.6.35-rc + radeoon-kms. I started the bisect but
> unfortunately I haven't finished due to some problems I came across
> and I'm not sure if I can continue it. I'm pointing below how the
> bisect went and - if you'd like to take a look - at the last point I
> explained why I stopped.
> 
> I did notice some pattern during this unfinished bisect though. And I
> think it may narrow down the regression to its source.
> 
> 
> 

Hi Alex!

I just pasted your good/bad results in my git and did look at it with

git bisect visualize


What I would do in your case is to try
612e06ce9c7884 radeon: Fix locking in power management paths

as that is the one just before your suspected bad commit. 

Definitely(well 98% certainty) you can skip any powerpc-commits that
are left as undecided... just try some commits in the drm/radeon range
there to either validate or invalidate your suspicion about f81f202402
(one of the vblank ones)

You can just do 'git reset --hard [commit you like to try]' to change
the commit you want to try next. (or use git bisect skip) 

Cheers,
Flo

p.s.: oh and of course trying the patches suggested by alex in the
other mail first is probably a wise thing to do...
