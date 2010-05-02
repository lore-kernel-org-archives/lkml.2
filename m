Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0EBBw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 21:52:56 -0400
Received: from tex.lwn.net ([70.33.254.29]:35105 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab0EBBwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 21:52:55 -0400
Date: Sat, 1 May 2010 19:52:51 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 24/30] viafb: Add a driver for the video capture engine
Message-ID: <20100501195251.50093ddb@bike.lwn.net>
In-Reply-To: <4BDCD2FD.8090104@gmx.de>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<1272493051-25380-25-git-send-email-corbet@lwn.net>
	<4BDCD2FD.8090104@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 May 2010 03:18:53 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> > +config FB_VIA_CAMERA
> > +	tristate "VIAFB camera controller support"
> > +	depends on FB_VIA
> > +	select VIDEOBUF_DMA_SG
> > +	help
> > +	   Driver support for the integrated camera controller in VIA
> > +	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
> > +	   with ov7670 sensors.
> > +  
> 
> Probably this is not the right place for this config option. Even if it 
> currently depends on the framebuffer having it there is just confusing. 

It's the wrong place for the driver as a whole; it needs to move to
drivers/media/video, and the configuration option with it.  As noted,
the camera driver isn't ready for submission yet; that's on a list of
about a half-dozen things that need fixing.  There's just a bit more
stuff to separate to make that move possible.

One other thing to consider is moving via-core, i2c, and gpio to
drivers/mfd.  It's perhaps a more logical place for it, but I'm not
sure there's a lot of value in making that move.

> Additionally you should depend/select some V4L stuff to make the 
> following compile errors go away:

OK.  A half-dozen plus one things to fix.

> Otherwise you can count this patch series as
> Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Although it is still far away from destination and has its issues but 
> it's a step forward and delaying it would be probably just frustrating 
> for both of us.

Thanks for reviewing it!

There are definitely things to fix, and I expect some of them to last
past the merge window.  But, hopefully, it's progress, and it's very
much my intention to continue to make things better.

jon
