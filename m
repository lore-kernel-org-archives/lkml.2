Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1CBPMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:12:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36672 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750831Ab1CBPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:12:23 -0500
Date: Wed, 2 Mar 2011 10:12:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Tardy <tardyp@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-mmc@vger.kernel.org>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
In-Reply-To: <201103020049.36902.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1103021010050.2015-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Rafael J. Wysocki wrote:

> > > How it works is, basically, that when the device signals wakeup, it either
> > > causes a PME# signal to be raised (parallel PCI), or a PME Message to be
> > > sent upstream (PCIe).  In the first case it will cause a platform event
> > > (eg. ACPI GPE) to occur and the handle of that event will resume your
> > > device (using pm_request_resume()).  In the second case it will cause the PCIe
> > > root port handling the PME Message to generate an interrupt and the handler of
> > > that interrupt will resume your device.
> > Thanks, that explain a lot how it works.
> > What I still dont understand is that the wake source I'll have (e.g.
> > sd card insert) is still an interrupt source.
> > So it is supposed to generate interrupt until the interrupt source is
> > acknowledged.
> > Are we supposed to mask that interrupt source while suspended to make
> > sure we have either wake or interrupt?
> 
> I think the interrupt should be masked while suspended and the driver's resume
> routine should unmask it.

Right.  That's how the PCI-based USB host controller drivers work.  
The suspend routine disables interrupt generation and enables PME
wakeup signals, and the resume routine does the reverse.

Alan Stern

