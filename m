Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab2GCRE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:04:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282Ab2GCREz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:04:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Boot regression on Mackerel with current mainline
Date: Tue, 3 Jul 2012 19:10:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207031218.24797.rjw@sisk.pl> <Pine.LNX.4.64.1207031336320.29890@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207031336320.29890@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031910.24864.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 03, 2012, Guennadi Liakhovetski wrote:
> Hi Rafael
> 
> On Tue, 3 Jul 2012, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > We seem to have a functional regression on Mackerel with 3.5-rc5 which
> > seems to be related to SDHI.  Namely, the SDHI driver appears to wait forever
> > for the devices to appear and commenting out all of the sdhi devices in the
> > board file works around the problem.
> > 
> > I can investigate some more later today if need be.
> 
> Have you checked the logs? Are you seeing any of these in the kernel log:
> 
> genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq 

I see this only once per boot, but then sh_mobile_sdhi is saying "timeout
waiting for hardware interrupt" pretty much continuously.

> with an IRQ number at the end? If so, then this is a known problem, which 
> I'd hoped would have been long fixed by now:
> 
> https://lkml.org/lkml/2012/6/12/151
> 
> We can nommit a fix for it in mmc, or we can try to re-ping Thomas - if 
> this is indeed the bug, you're getting...

I guess it is, but having reviewed the above e-mail thread I don't think any
fix from Thomas is going to appear.  So, please fix that in MMC, if possible.

Thanks,
Rafael
