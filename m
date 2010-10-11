Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0JKKwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 06:52:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40683 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0JKKwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 06:52:44 -0400
Date: Mon, 11 Oct 2010 11:52:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Arnd Hannemann <arnd@arndnet.de>,
        Hemant Pedanekar <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101011105216.GD27153@n2100.arm.linux.org.uk>
References: <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <20101009000046.GA30616@kroah.com> <20101009002546.GB14675@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1010082210150.3107@xanadu.home> <1286791544.19739.31.camel@e102109-lin.cambridge.arm.com> <AANLkTinMuKDpbL9ka61QhUFJfze_HWWHxjUbAqbz2_vi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinMuKDpbL9ka61QhUFJfze_HWWHxjUbAqbz2_vi@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 01:39:13PM +0300, Felipe Contreras wrote:
> Anyway, I'm reading the TRM and I can't find any mention of this.
> Catalin, can you point out where is this mentioned, and also, can you
> confirm if this would affect only the memory that has the double
> mapping, or it can corrupt other memory as well?

Page A3-31:

  If the same memory locations are marked as having different cacheability
  attributes, for example by the use of aliases in a virtual to physical
  address mapping, behavior is UNPREDICTABLE.

Page A3-36:

  Behavior is UNPREDICTABLE if the same memory location:
   ■ is marked as Shareable Normal and Non-shareable Normal
   ■ is marked as having different memory types (Normal, Device, or Strongly-
     ordered)
   ■ is marked as having different cacheability attributes
   ■ is marked as being Shareable Device and Non-shareable Device memory.

  Such memory marking contradictions can occur, for example, by the use of
  aliases in a virtual to physical address mapping.

And from the glossary:

  UNPREDICTABLE Means the behavior cannot be relied upon. UNPREDICTABLE
  behavior must not represent security holes. UNPREDICTABLE behavior must
  not halt or hang the processor, or any parts of the system. UNPREDICTABLE
  behavior must not be documented or promoted as having a defined effect.
