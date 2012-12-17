Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2LQXPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:15:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2LQXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:15:05 -0500
Date: Tue, 18 Dec 2012 00:15:01 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: i915: GPU hang
Message-ID: <20121217231501.GA7108@fancy-poultry.org>
References: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+73 (c4c65eadeb71) (2011-07-01)
X-Provags-ID: V02:K0:brAbfyN6q9SbkF/rv0/xECFlMQa7/GMyTC2oKc0SP+d
 Ssr4ZPCVAvhwcGI5qekKuHGufyd91o9PItMy690q9MmTsnh/Hu
 2ffni4fIos2MXDFSZa73fUZyXQJ1ih1rK8zr00fLi5SOe5oDTq
 Ie6rECD+0Uvn6Td/qffS5ZCrI3zlYVHCQ1MZGeWBcla8o0UAgk
 HBQNDadkNWN6NWEN06GWK/CggKG0qb61Tl1Fjx6bPtGzxOsqcz
 XMl1yY9eXWWkzwPFFo2yEgzqmbe7PAlyr9XliK4JeKgyPh+mav
 +mEIzs9d9PaM3/o2ZKOPMszSWrvKrXrwHkPpB0XnOnVdfYcsyX
 ovoHSjE4qUnTDyskDsqnxXTLNUg6tCyqu+uS3QCdL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.12.2012, Guennadi Liakhovetski wrote: 

> [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
> [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
> [drm:i915_reset] *ERROR* Failed to reset chip.

I have the same problem, are able to reproduce it and have bisected
it, but the commit which git --bisect identified seems not to be the
cause.

root@wildsau linux-git]# git bisect good
6c085a728cf000ac1865d66f8c9b52935558b328 is the first bad commit
commit 6c085a728cf000ac1865d66f8c9b52935558b328
Author: Chris Wilson <ch...@chris-wilson.co.uk>
Date:   Mon Aug 20 11:40:46 2012 +0200

    drm/i915: Track unbound pages


This is a quite nasty (3.7) regression. I have it on all of my three
machines and it drives me mad (3.6.x hangs my USB 3.0 port and 3.7 my
intel graphics).

Try to boot with "i915.i915_enable_rc6=0" and switch to SNA in your
Xorg.conf:

Section "Device"
   Identifier "Card0"
   Driver "intel"
   Option "AccelMethod" "SNA"
EndSection

There are tons of this "GPU hangcheck timer elapsed"
messages on the net...

Good luck!

