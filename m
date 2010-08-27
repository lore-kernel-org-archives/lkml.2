Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0H0EmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 00:42:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51601 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab0H0EmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 00:42:09 -0400
Date: Fri, 27 Aug 2010 06:41:42 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: g.liakhovetski@gmx.de, mitov@issp.bas.bg, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        philippe.retornaz@epfl.ch, gregkh@suse.de, jkrzyszt@tis.icnet.pl
Subject: Re: [RFC][PATCH] add
	dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Message-ID: <20100827044142.GB31863@pengutronix.de>
References: <Pine.LNX.4.64.1008261100150.14167@axis700.grange> <20100826182915S.fujita.tomonori@lab.ntt.co.jp> <20100826095311.GA13051@pengutronix.de> <20100826185938A.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100826185938A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 26, 2010 at 07:00:24PM +0900, FUJITA Tomonori wrote:
> On Thu, 26 Aug 2010 11:53:11 +0200
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> 
> > > > We have currently a number of boards broken in the mainline. They must be 
> > > > fixed for 2.6.36. I don't think the mentioned API will do this for us. So, 
> > > > as I suggested earlier, we need either this or my patch series
> > > > 
> > > > http://thread.gmane.org/gmane.linux.ports.sh.devel/8595
> > > > 
> > > > for 2.6.36.
> > > 
> > > Why can't you revert a commit that causes the regression?
> > > 
> > > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > > responsible for the regression. And the patchset even exnteds the
> > > definition of the DMA API (dma_declare_coherent_memory). Such change
> > > shouldn't applied after rc1. I think that DMA-API.txt says that
> > > dma_declare_coherent_memory() handles coherent memory for a particular
> > > device. It's not for the API that reserves coherent memory that can be
> > > used for any device for a single device.
> > The patch that made the problem obvious for ARM is
> > 309caa9cc6ff39d261264ec4ff10e29489afc8f8 aka v2.6.36-rc1~591^2~2^4~12.
> > So this went in before v2.6.36-rc1.  One of the "architectures which
> > similar restrictions" is x86 BTW.
> > 
> > And no, we won't revert 309caa9cc6ff39d261264ec4ff10e29489afc8f8 as it
> > addresses a hardware restriction.
> 
> How these drivers were able to work without hitting the hardware restriction?
In my case the machine in question is an ARMv5, the hardware restriction
is on ARMv6+ only.  You could argue that so the breaking patch for arm
should only break ARMv6, but I don't think this is sensible from a
maintainers POV.  We need an API that works independant of the machine
that runs the code.  And it's good to let developers that don't have the full
range of machines supported by the kernel at hand notice when they
introduce an incompatibility.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
