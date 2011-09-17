Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1IQU0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 16:26:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40648 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756048Ab1IQU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 16:26:13 -0400
Date: Sat, 17 Sep 2011 21:25:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Rob Clark <rob@ti.com>, Felipe Contreras <felipe.contreras@gmail.com>,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110917212529.6b452bf2@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPM=9txHu7mzH8p8g=FmHsjvmAT-aMy-xEFj4odXEvnbs-bhMw@mail.gmail.com>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
	<CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
	<4E74C6C3.2000704@gmx.de>
	<CAPM=9twmPVrBPmUuEuTYHSzjDGHtfsmiVX6cozpAFYEaV-NcCg@mail.gmail.com>
	<4E74E3D6.8080401@gmx.de>
	<CAPM=9txHu7mzH8p8g=FmHsjvmAT-aMy-xEFj4odXEvnbs-bhMw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just tell the X driver to not use acceleration, and it you won't get
> any acceleration used, then you get complete stability. If a driver
> writer wants to turn off all accel in the kernel driver, it can, its

In fact one thing we actually need really is a "dumb" KMS X server to
replace the fbdev X server that unaccel stuff depends upon and which
can't do proper mode handling, multi-head or resizing as a result. A dumb
fb generic request for a back to front copy might also be useful for
shadowfb, or at least indicators so you know what the cache behaviour is
so the X server can pick the right policy.

> We've fixed this in KMS, we don't pass direct mappings to userspace
> that we can't tear down and refault. We only provide objects via
> handles. The only place its a problem is where we expose fbdev legacy
> emulation, since we have to fix the pages.

Which is doable. Horrible but doable. The usb framebuffer code has to
play games like this with the virtual framebuffer in order to track
changes by faulting.

There are still some architectural screwups however. DRM continues the
fbdev worldview that outputs, memory and accelerators are tied together
in lumps we call video cards. That isn't really true for all cases and
with capture/overlay it gets even less true.

Alan
