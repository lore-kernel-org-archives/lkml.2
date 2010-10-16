Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0JPCkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:40:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:45831 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab0JPCkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:40:18 -0400
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20101009000046.GA30616@kroah.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	 <20101007192245.GC26435@n2100.arm.linux.org.uk>
	 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	 <20101008175308.GA10975@n2100.arm.linux.org.uk>
	 <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	 <20101008230451.GB10975@n2100.arm.linux.org.uk>
	 <20101008232539.GA28697@kroah.com>
	 <20101008234448.GD10975@n2100.arm.linux.org.uk>
	 <20101009000046.GA30616@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 13:39:49 +1100
Message-ID: <1287196789.2370.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 17:00 -0700, Greg KH wrote:
> 
> But you can't expect that you make this change, and not fix up the
> drivers, and people would be happy, right?  The rule for API changes
> like this, or anything, is that the person making the change fixes the
> other drivers, and that seems to be the issue here.
> 
> Any pointers to patches where people have fixed up the drivers?

Greg, this is true for normal API changes. In this case, this is silent
data corruption, I think Russell is absolutely right. That exact same
issues have been giving me nightmares on powerpc, mostly due to
(fortunately extremely rare) broken chipsets doing non coherent DMA on
processors that do not allow you architecturally to double map memory
with different attributes.

Cheers,
Ben.


