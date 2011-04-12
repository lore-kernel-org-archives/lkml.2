Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1DLXzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:55:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:46409 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1DLXzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:55:20 -0400
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1302646173.28876.53.camel@pasglop>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	 <1302646173.28876.53.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 09:55:02 +1000
Message-ID: <1302652502.28876.76.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Finally I tried using g5_defconfig with 2.6.39-rc3.  First boot
> > it did get to /sbin/init, but udev init took much longer than
> > normal and threw errors.  After a warm reboot the same kernel
> > hung as usual, this time before framebuffer init.
> > 
> > 2.6.38 works just fine.
> 
> Hrm, that must be new, I remember testing something around -rc1 on a
> similar machine and it worked fine. I'll see if I can find something
> out.

Ok so on a PowerMac7,3 here (dual 2.5Ghz and mostly same HW or at least
very similar) I can't reproduce your problem with a g5_defconfig.

Your config doesn't work well for me (I don't do modules, I netboot),
but after adding a few things to it, it seems to work fine as well. I
added radeonfb and the radeon DRM (not KMS) and I added eventfd, timerfd
and input events.

So I'm afraid I'm going to need you to bisect that one to find out what
exact change caused the breakage for you.

Cheers,
Ben.

