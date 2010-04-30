Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab0D3SXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:23:00 -0400
Received: from tex.lwn.net ([70.33.254.29]:42906 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204Ab0D3SWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:22:42 -0400
Date: Fri, 30 Apr 2010 12:22:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Bruno =?ISO-8859-1?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 13/30] viafb: Separate global and fb-specific data
Message-ID: <20100430122236.2357c034@bike.lwn.net>
In-Reply-To: <4BDB1C46.8020101@gmx.de>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<1272493051-25380-14-git-send-email-corbet@lwn.net>
	<20100429201902.6379f8d3@neptune.home>
	<20100430102157.5eb59055@bike.lwn.net>
	<4BDB1C46.8020101@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 20:07:02 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> Please don't do this. The reason for not failing in viafb is that 
> ioremap failure of the engine is not critical it just disables the 
> hardware acceleration but otherwiese it works quite nice. The problem is 
> that ioremap failures are quite common as we really try to remap huge 
> amount (sometimes above 128 or even 256 MB). 

But...this region is small should never be hard to remap.  Are you sure
you've seen trouble with the engine region?

> In fact the bug (or missing 
> feature) is that the first ioremap is fatal and that needs to be fixed 
> on the long run. Sorry but I don't want to make viafb unusable for many 
> people if they don't add the "vmalloc=" kernel option so failing here 
> would be a step in the wrong direction.

Is the real problem, perhaps, that we're remapping the entire
framebuffer?  One wonders if we could get away without doing that.
Some quick greppery suggests that the cursor code goes straight to a
small region of framebuffer memory.  With working acceleration, we
shouldn't need cfb_*().  But, probably, I'm missing something?

Meanwhile, I can let initialization continue without the engine space.
It kills interrupts/dma/camera, of course, but so be it.

jon
