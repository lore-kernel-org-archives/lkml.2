Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0JAIfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 04:35:54 -0400
Received: from mail.southpole.se ([193.12.106.18]:53520 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0JAIfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 04:35:53 -0400
Subject: Re: ioremap definition in generic io.h
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201009301404.36551.arnd@arndb.de>
References: <1285747145.12259.3.camel@needafix>
	 <201009301345.16817.arnd@arndb.de> <1285847579.2639.3.camel@needafix>
	 <201009301404.36551.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Fri, 01 Oct 2010 10:35:50 +0200
Message-ID: <1285922150.2639.37.camel@needafix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for the detailed explanation... it's started to make sense now.

> I assume that microblaze is a special case here because you synthesize
> the I/O devices together with the CPU core and choose a common endianess
> for both, right?

Yeah, that's exactly the case I'm looking at.  I'm actually working on
OpenRISC and not Microblaze, but that's just a detail!  The same issues
are applicable to both architectures.

> We have the __raw_readl()/__raw_writel() functions which are defined as
> host-endian, but I would not recommend using them in general because they
> also mean slightly different things depending on the architecture.

OK, I'm curious what you mean here... I would have thought that wrapping
our own functions around these would have been the right way to do
things.  What subtleties exist here that I would need to look out for?

> It's probably best to define your own functions for microblaze. Obviously
> the drivers are not portable to other architectures anyway because those
> might be cross-endian.
> 
> It's probably best to name the accessors by the bus that the devices
> are attached to, and then define them in a a per-bus header file, like
> 
> #ifdef CONFIG_PLB_BIG_ENDIAN
> #define plb_ioread32(p) ioread32be(p)
> #define plb_iowrite32(p) iowrite32be(p)
> #else
> #define plb_ioread32(p) ioread32(p)
> #define plb_iowrite32(p) iowrite32(p)
> #endif
> 

This seems like a reasonable approach.  What got me looking at all of
this was that I wanted to use asm-generic/io.h for our architecture, and
it's mostly OK except for the definition of ioremap which implies NOMMU.
Wouldn't it make sense to drop the ioremap definitions from this file,
thus allowing it to be used by archictectures with MMU?  Or do you know
of something more in this file which prohibits it from being used more
"generically"?

Thanks for your helpful feedback!
/Jonas

