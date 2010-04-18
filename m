Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0DRRee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 13:34:34 -0400
Received: from tex.lwn.net ([70.33.254.29]:45792 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab0DRRec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 13:34:32 -0400
Date: Sun, 18 Apr 2010 11:34:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/16] viafb: Determine type of 2D engine and store it
 in chip_info
Message-ID: <20100418113430.53760f99@bike.lwn.net>
In-Reply-To: <4BBF8F48.2070902@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-6-git-send-email-corbet@lwn.net>
	<4BBE9CFC.2020804@gmx.de>
	<20100409141127.42e4e1fa@bike.lwn.net>
	<4BBF8F48.2070902@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Getting back to the older stuff...]

On Fri, 09 Apr 2010 22:34:16 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> >> Just a minor nit:
> >> Could we change the default so that if someone adds support for a new 
> >> IGP (and misses this function) we default to either the newest or 
> >> preferably to none? I've just seen too much poorly maintained code in 
> >> this driver and defaulting to the oldest is hence a bad idea.
> >> Otherwise it's fine.  
> > 
> > That would require making an exhaustive list of older chipset types.
> > It could probably be inferred through inspection of the code, but I
> > worry about making assumptions in this area...  
> 
> Such list already exists. gfx_chip_name = pdi->driver_data in hw.c (and 
> only there) so what is needed is the list viafb_pci_table in viafbdev.c 
> (relatively at the end) of all chips:

I've spent a bit of time looking at this.  What's really needed is a
better way of abstracting the chip types so that we can maybe get rid
of all those switch statements throughout the driver.  For the purposes
of getting this work in, I'm not quite prepared to make that change,
though I could certainly consider doing it in the future.

In the absence of that, the only course of action which makes sense is
to simply fail the initialization if an unknown chip type shows up
there.  That's easy, and I can do it.  But, given that this was a
"minor nit," can we leave it as-is for now?  There's a *lot* of things
to clean up in this driver, I'd like to make it better a step at a time
rather than trying to do the whole thing at once.

Thanks,

jon
