Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab0KOWLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:11:51 -0500
Received: from relais.videotron.ca ([24.201.245.36]:61767 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0KOWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:11:50 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_AaH04fu+1Q3K/BE3awls0g)"
Date: Mon, 15 Nov 2010 17:11:50 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long for
 32-bit ptes
In-reply-to: <AANLkTi=FFpCwEhSgs-zOh32JQvqQWqnaQVTitwJeDyzj@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1011151707310.6448@xanadu.home>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
 <20101114151445.GB10871@n2100.arm.linux.org.uk>
 <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
 <201011151047.37103.arnd@arndb.de>
 <AANLkTi=FFpCwEhSgs-zOh32JQvqQWqnaQVTitwJeDyzj@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Content-id: <alpine.LFD.2.00.1011151710070.6448@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_AaH04fu+1Q3K/BE3awls0g)
Content-id: <alpine.LFD.2.00.1011151710071.6448@xanadu.home>
Content-type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-transfer-encoding: 8BIT

On Mon, 15 Nov 2010, Catalin Marinas wrote:

> On 15 November 2010 09:47, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 15 November 2010 10:39:30 Catalin Marinas wrote:
> >> > There will be compiler warnings because u32 is unsigned int, and we
> >> > print it as %08lx.  Generic code cases pte values to (long long) and
> >> > prints them using %08llx.  We should do the same.
> >>
> >> We still need some kind of macro because with LPAE we need %016llx
> >> since the phys address can go to 40-bit and there are some additional
> >> bits in the top word. Unless you'd like to always print 16 characters
> >> even for 32-bit ptes (or if there is some other printk magic I'm not
> >> aware of).
> >
> > Why not just %010llx? That would just be two extra characters.
> 
> We still have attributes (like XN, bit 54) stored in the top part of
> the pte. This may be of interest when debugging.

They will be printed if they exist. The %010 in front of llx only means 
to have a minimum of 10 zero-paded digits if the value is smaller than 
that.

However, not having aligned values will be confusing.  A macro for the 
format might be the best compromize.


Nicolas

--Boundary_(ID_AaH04fu+1Q3K/BE3awls0g)--
