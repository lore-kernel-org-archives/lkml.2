Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab0JOUk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:40:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0JOUk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:40:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 5/5] pci: Add support for polling PME state on suspended legacy PCI devices
Date: Fri, 15 Oct 2010 22:39:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <1286216549-5438-1-git-send-email-mjg@redhat.com> <1286216549-5438-6-git-send-email-mjg@redhat.com> <20101015131028.7fffba40@jbarnes-desktop>
In-Reply-To: <20101015131028.7fffba40@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010152239.50316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 15, 2010, Jesse Barnes wrote:
> On Mon,  4 Oct 2010 14:22:29 -0400
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > Not all hardware vendors hook up the PME line for legacy PCI devices,
> > meaning that wakeup events get lost. The only way around this is to poll
> > the devices to see if their state has changed, so add support for doing
> > that on legacy PCI devices that aren't part of the core chipset.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > ---
> >  drivers/pci/pci.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 77 insertions(+), 0 deletions(-)
> 
> Yuck, polling.  But I guess we don't have an alternative short of
> rewiring all the cheap platforms out there!
> 
> So, applied.

Actually, the next step should be to avoid polling for the devices that
do signal wakeup normally.  That is, if wakeup interrupts or notifications are
coming for the device, we'll drop it from the list.  This looks doable.

Thanks,
Rafael
