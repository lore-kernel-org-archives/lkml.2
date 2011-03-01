Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1CAT5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:57:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51100 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757176Ab1CAT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:57:05 -0500
Date: Tue, 1 Mar 2011 14:57:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Tardy <tardyp@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
In-Reply-To: <AANLkTi=ogThxB_2bxANV4hUsLGZs04gzHSCyH90Bm87U@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103011454250.2034-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Pierre Tardy wrote:

> On Tue, Mar 1, 2011 at 8:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 1 Mar 2011, Pierre Tardy wrote:
> >
> >> Please find sdhci runtime_pm implementation.
> >>
> >> It uses clock gating fw as a tip to know when our chip is idle.
> >> It implements wake up from card insertion/removal.
> >>
> >> This is RFC, please dont merge yet. I really would like to have deep review
> >> from PCI linux-pm guys.
> >>
> >> Opens are:
> >>
> >> 1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
> >>  are not duplicate from what the core is doing.
> >
> > There may be one or two small errors.
> >
> >> 2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,
> >
> > Other drivers do it, but they use PCI PME# instead of interrupts.
> Could you please elaborate?
> My understanding is that PCI PME will generate MSI, which translate in
> interrupt.

It depends on the platform.  On systems with ACPI, PCI PME generates an 
ACPI I/O event, which is handled by the ACPI and PM cores.  It does not 
invoke the device driver's interrupt handler.

Alan Stern

