Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0DWWxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 18:53:00 -0400
Received: from tex.lwn.net ([70.33.254.29]:50071 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab0DWWw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 18:52:59 -0400
Date: Fri, 23 Apr 2010 16:52:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA
 framebuffer driver
Message-ID: <20100423165256.654ca5eb@bike.lwn.net>
In-Reply-To: <4BD221E7.7060705@gmx.de>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
	<1271614873-5952-11-git-send-email-corbet@lwn.net>
	<4BD20D56.7080402@gmx.de>
	<20100423155725.7d3b2d2d@bike.lwn.net>
	<4BD221E7.7060705@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Apr 2010 00:40:39 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> Actually that is probably a mistake on my side. I had the impression 
> that it was much longer but didn't take into account that the old 
> behaviour allowed the VGA console to work until viafb was completly 
> loaded and fbcon took over while the new one immediately destroys the 
> screen and shows random things until it is completely loaded. 

"New one" being new relative to what?  Is that change the result of the
patches I've posted, or something else?

> > As for #2, I can certainly say that I've never unloaded this code, so
> > that's an untested path.  I'll have a look and see if I can see
> > anything obvious.  
> 
> Well as for the behaviour change described above I think the problem 
> might be in the load path. At least when I faked an exit as when memory 
> size detection or ioremapping fails (which is a very common issue that 
> really needs a workaround) I get the same unusable VGA console. This 
> needs to be fixed.

Interesting.  In the environment I've been working in the whole box is
a brick if the framebuffer doesn't come up right.  But things are
pretty solid on that front here.

> This whole I2C stuff seems incredibly unstable I even have indicators 
> that the current code might be to blame for freezing the machine on some 
> configurations with P4M900 IGP. I just try to prevent it to get even 
> worse...

I have to say that i2c has often been the bane of my existence.  It
seems like something that just barely works most of the time.

That said, it's been a long time since I've seen any trouble I could
blame on i2c in the viafb driver.  It's *really* hard to imagine how
it could free machines.  Unless, maybe, you're hitting some sort of
race condition in all of those indexed I/O port operations.  But that
looks like something which would be hard to do on most machines that
would have these chipsets in them.

The second series adds some locking around i2c port operations, but has
not yet pushed that locking into the framebuffer side of the driver;
that would be a good thing to do.

Meanwhile, I'm a little unsure now...is there an action item for me
with regard to the i2c code?  I've been staring at it since your last
note, but I couldn't find any obvious problems.  I do have to say that
Harald's rework is far cleaner than what came before...

Thanks,

jon
