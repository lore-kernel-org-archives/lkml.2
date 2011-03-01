Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1CAUab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:30:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51145 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757148Ab1CAUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:30:30 -0500
Date: Tue, 1 Mar 2011 15:30:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Tardy <tardyp@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
In-Reply-To: <AANLkTik5HVxoOCH1ZVj50nUsCA5E04Y0J0RaWw7_KyKw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103011528230.2034-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Pierre Tardy wrote:

> >> > Other drivers do it, but they use PCI PME# instead of interrupts.
> >> Could you please elaborate?
> >> My understanding is that PCI PME will generate MSI, which translate in
> >> interrupt.
> >
> > It depends on the platform.  On systems with ACPI, PCI PME generates an
> > ACPI I/O event, which is handled by the ACPI and PM cores.  It does not
> > invoke the device driver's interrupt handler.
> So, let's say, in the ACPI case, if the interrupt handler dont get
> called, how would the driver know that he got a sdcard insert event,
> and trigger a mmc_rescan() ?

When the ACPI and PCI cores process the PME event, they call
pm_runtime_resume().  The driver's runtime_resume routine would read
the device status and see the insert event, which would cause it to
trigger mmc_rescan().

Alan Stern

