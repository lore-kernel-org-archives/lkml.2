Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0JKJ1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:27:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64029 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab0JKJ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:27:06 -0400
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20101009164517.GA28183@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	 <20101009135210.GA25564@n2100.arm.linux.org.uk>
	 <AANLkTi=Sv35ipSGzSoJMjdoNU-Qee9csviPL3yMSM3uf@mail.gmail.com>
	 <20101009164517.GA28183@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 11 Oct 2010 10:26:35 +0100
Message-ID: <1286789195.19739.5.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2010 09:26:36.0459 (UTC) FILETIME=[66CD37B0:01CB6926]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-09 at 17:45 +0100, Russell King - ARM Linux wrote:
> On Sat, Oct 09, 2010 at 07:07:01PM +0300, Felipe Contreras wrote:
> > On Sat, Oct 9, 2010 at 4:52 PM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
> > >> For issues related to this:
> > >> http://article.gmane.org/gmane.linux.ports.arm.kernel/84454
> > >
> > > This one nicely shows some of the problems which can occur with the
> > > memory type attributes - and this is not attributable to ioremap().
> > >
> > > ioremap() is used to map devices.  It creates device memory type mappings.
> > > If what you're mapping doesn't support device memory type mappings, then
> > > accesses via an ioremap()'d region isn't going to work - as this guy is
> > > observing.
> > >
> > > That's not because ioremap() is doing something wrong.  It's doing what
> > > it's meant to do.  The use is wrong, and is completely unrelated to the
> > > issue you've raised.
> >
> > Ok, I was confused by Catalin's comment which does point to ioremap()
> > on normal RAM:
> > http://article.gmane.org/gmane.linux.ports.arm.kernel/84504
> 
> Me too - it doesn't appear to relate to the specified problem.  You
> don't want to map RAM as device nor strongly ordered, and we still
> don't know what this "MMR" is.

I don't know what MMR is either. But my comment is misleading, I think I
was thinking about dma_alloc_coherent().

We could to allow ioremap_wc() or ioremap_cached() to normal RAM but
that's probably outside the scope of ioremap* (and it would require
initial cache maintenance to remove potential dirty cache lines).

-- 
Catalin

