Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1CAXt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:49:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab1CAXt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:49:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Tardy <tardyp@gmail.com>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
Date: Wed, 2 Mar 2011 00:49:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org
References: <cover.1298820825.git.tardyp@gmail.com> <201103012207.22798.rjw@sisk.pl> <AANLkTinNG9ecqSGk+zDjd0A+nLXmwHQkRot0WZ18amsv@mail.gmail.com>
In-Reply-To: <AANLkTinNG9ecqSGk+zDjd0A+nLXmwHQkRot0WZ18amsv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103020049.36902.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 02, 2011, Pierre Tardy wrote:
> On Tue, Mar 1, 2011 at 10:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, March 01, 2011, Pierre Tardy wrote:
> >> On Tue, Mar 1, 2011 at 8:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> > On Tue, 1 Mar 2011, Pierre Tardy wrote:
> >> >
> >> >> Please find sdhci runtime_pm implementation.
> >> >>
> >> >> It uses clock gating fw as a tip to know when our chip is idle.
> >> >> It implements wake up from card insertion/removal.
> >> >>
> >> >> This is RFC, please dont merge yet. I really would like to have deep review
> >> >> from PCI linux-pm guys.
> >> >>
> >> >> Opens are:
> >> >>
> >> >> 1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
> >> >>  are not duplicate from what the core is doing.
> >> >
> >> > There may be one or two small errors.
> >> >
> >> >> 2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,
> >> >
> >> > Other drivers do it, but they use PCI PME# instead of interrupts.
> >> Could you please elaborate?
> >> My understanding is that PCI PME will generate MSI, which translate in
> >> interrupt.
> >
> > Your driver won't get those interrupts.
> >
> > How it works is, basically, that when the device signals wakeup, it either
> > causes a PME# signal to be raised (parallel PCI), or a PME Message to be
> > sent upstream (PCIe).  In the first case it will cause a platform event
> > (eg. ACPI GPE) to occur and the handle of that event will resume your
> > device (using pm_request_resume()).  In the second case it will cause the PCIe
> > root port handling the PME Message to generate an interrupt and the handler of
> > that interrupt will resume your device.
> Thanks, that explain a lot how it works.
> What I still dont understand is that the wake source I'll have (e.g.
> sd card insert) is still an interrupt source.
> So it is supposed to generate interrupt until the interrupt source is
> acknowledged.
> Are we supposed to mask that interrupt source while suspended to make
> sure we have either wake or interrupt?

I think the interrupt should be masked while suspended and the driver's resume
routine should unmask it.

Thanks,
Rafael
