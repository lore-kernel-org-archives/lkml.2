Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab0KOWHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:07:20 -0500
Received: from relais.videotron.ca ([24.201.245.36]:43292 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641Ab0KOWHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:07:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 15 Nov 2010 17:07:14 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long for
 32-bit ptes
In-reply-to: <201011151047.37103.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1011151706300.6448@xanadu.home>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
 <20101114151445.GB10871@n2100.arm.linux.org.uk>
 <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
 <201011151047.37103.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Arnd Bergmann wrote:

> On Monday 15 November 2010 10:39:30 Catalin Marinas wrote:
> > > There will be compiler warnings because u32 is unsigned int, and we
> > > print it as %08lx.  Generic code cases pte values to (long long) and
> > > prints them using %08llx.  We should do the same.
> > 
> > We still need some kind of macro because with LPAE we need %016llx
> > since the phys address can go to 40-bit and there are some additional
> > bits in the top word. Unless you'd like to always print 16 characters
> > even for 32-bit ptes (or if there is some other printk magic I'm not
> > aware of).
> 
> Why not just %010llx? That would just be two extra characters.

Not on non-LPAE build, please.


Nicolas
