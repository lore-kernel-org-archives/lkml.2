Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2L3Wxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 17:53:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2L3Wxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 17:53:33 -0500
Date: Sun, 30 Dec 2012 23:53:23 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
Subject: Re: i915: GPU hang
Message-ID: <20121230225323.GA7764@fancy-poultry.org>
References: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
 <CAKMK7uHvqJbXqass9UTT-sUOxnggrUFouNA7019htq2445i_FQ@mail.gmail.com>
 <Pine.LNX.4.64.1212302141120.19832@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1212302141120.19832@axis700.grange>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+116 (b0265d385207) (2011-07-01)
X-Provags-ID: V02:K0:0gbwlMzrpV3dS3slzdyTjPclLpkdfREUvSTUDvwm0SQ
 xsTSpUYPXd3qjwToK+F+hA2IoHt/Ad6fu0vMx20A3W3iAg3CFr
 9omWWgynbll2Dbp8ixlEsvsZlrDPrt1UKkhUN3fWSBXvrRc2R/
 E2ZHB2YUoavXFOJAHkfnLFp0aJJ4sjySl2XMTY/ezanWFEK7aG
 EeMFZa/mW6c3b8eVW9yAmzLWXZ56YFeYRjRFjhRsGVXuxHwSMm
 PVex3LtGNF+270aE49Uz+zNcDjSUP+rVBJt13Rb48kxxqLAGsa
 UBi791cwcZmUFYNh8AOpLZyGfEeVmZ/y3qCzGcbJpQjmnI9hsI
 zWEuGDiwnAoPppOSjr7M4cTWaF8ID21i8NvORy3aQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.12.2012, Guennadi Liakhovetski wrote: 

> Did that and it did work for a while, longer than the average with 3.5. I 
> was already about to write a success report, but then it hung again 
> yesterday. I'm not using this laptop very intensively, so, it is hard to 
> collect statistics.

You could try to reproduce the error by writing a big file e.g.

 dd if=/dev/zero of=deleteme bs=1M count=80000

or similar and watching high definition video on Youtube (1080p) or running a few
instances of glxgears. That triggers a gpu hang in my case after
just a couple of seconds.

In my case, the hang doesn't occur when using SNA (or a kernel < 3.7,
which isn't the case with your bug). I have this in my
xorg.conf:

Section "Device"
   Identifier "Card0"
   Driver "intel"
   Option "AccelMethod" "SNA"
EndSection

Without this, every 3.7 kernel produces a gpu hang within max. 1 min.

 
