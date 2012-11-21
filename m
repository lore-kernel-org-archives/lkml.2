Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193Ab2KUUx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:53:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40606 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964798Ab2KUUx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:53:57 -0500
Message-ID: <1353531235.24807.39.camel@joe-AO722>
Subject: Re: [PATCH RESEND] acpi: Fix logging when no pci_irq is allocated
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2012 12:53:55 -0800
In-Reply-To: <1483298.SPL34HcZVJ@vostro.rjw.lan>
References: <1353487401-10279-1-git-send-email-daniel@numascale-asia.com>
	 <1353505564.24807.12.camel@joe-AO722> <1483298.SPL34HcZVJ@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-21 at 21:50 +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 21, 2012 05:46:04 AM Joe Perches wrote:
> > On Wed, 2012-11-21 at 16:43 +0800, Daniel J Blueman wrote:
> > > Previously a new line is implicitly added in the no GSI case:
> > > 
> > > [    7.185182] pci 0001:00:12.0: can't derive routing for PCI INT A
> > > [    7.191352] pci 0001:00:12.0: PCI INT A: no GSI
> > > [    7.195956]  - using ISA IRQ 10
> > > 
> > > The code thus prints a blank line where no legacy IRQ is available:
> > > 
> > > [    1.650124] pci 0000:00:14.0: can't derive routing for PCI INT A
> > > [    1.650126] pci 0000:00:14.0: PCI INT A: no GSI
> > > [    1.650126] 
> > > [    1.650180] pci 0000:00:14.0: can't derive routing for PCI INT A
> > > 
> > > Fix this by making the newline explicit and removing the superfluous
> > > one.
> > 
> > This breaks the logging code below it when there is an ISA irq.
> > 
> > The below works, but is a workaround for a defect in the printk
> > subsystem introduced by a logging change that will be fixed in
> > a near future release.
> 
> What exactly do you mean by "near future"?

I mean Jan Schönherr's patches that should fix this are
likely to be picked up one day.

https://lkml.org/lkml/2012/11/13/678


