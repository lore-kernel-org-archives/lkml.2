Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab2JKPns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:43:48 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17999 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2JKPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:43:46 -0400
Message-ID: <1349969788.23493.54.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 0/4] ACPI: Refactor system notify handling
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, bhelgaas@google.com,
        liuj97@gmail.com, isimatu.yasuaki@jp.fujitsu.com
Date: Thu, 11 Oct 2012 09:36:28 -0600
In-Reply-To: <1349790916.23493.5.camel@misato.fc.hp.com>
References: <1346974828-12500-1-git-send-email-toshi.kani@hp.com>
	 <1349790916.23493.5.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Can you please review this patchset?

Thanks,
-Toshi


On Tue, 2012-10-09 at 07:55 -0600, Toshi Kani wrote:
> Hi Len,
> 
> Can you please review this patchset?  Please let me know if you have any
> concern/question.
> 
> Thanks,
> -Toshi
> 
> 
> On Thu, 2012-09-06 at 17:40 -0600, Toshi Kani wrote:
> > This patchset updates the ACPI system-level (ex. hotplug)
> > notify handling with a new .sys_notify interface.  It provides
> > the following changes:
> > 
> > - Allow ACPI drivers to register their system-level (hotplug)
> >   notify handlers to a new .sys_notify interface through their
> >   acpi_driver table.  This removes redundant ACPI namespace
> >   walks from ACPI drivers for faster booting.  The global notify
> >   handler acpi_bus_notify() is called for all system-level ACPI
> >   device notifications, which then calls an appropriate driver's
> >   handler if any.  ACPI drivers no longer need to register or
> >   unregister driver's handlers to each device object in ACPI
> >   namespace.
> >  
> > - Support dynamic ACPI namespace with LoadTable & Unload opcode
> >   without any changes in ACPI drivers.  There is no need to 
> >   register / unregister handlers to ACPI device objects that are
> >   being loaded to / unloaded from ACPI namespace.
> > 
> > - Allow ACPI drivers to use a common hotplug handler when it is
> >   implemented.  It removes functional conflict between driver's
> >   notify handler and the global notify handler acpi_bus_notify().
> >   acpi_bus_notify() only calls an appropriate notify handler if
> >   any.
> > 
> > Note that the changes maintain backward compatibility for ACPI
> > drivers.  Any drivers registered their hotplug handlers through
> > the existing interfaces, such as acpi_install_notify_handler()
> > and register_acpi_bus_notifier(), will continue to work as before.
> > 
> > v2:
> >  - Protected unbound driver from unloading when calling .sys_notify.
> >  - Changed acpi_bus_notify() to call acpi_bus_notify_list first for
> >    maintaining the original order.
> > 
> > ---
> > Toshi Kani (4):
> >  ACPI: Support system notify handler via .sys_notify
> >  ACPI: Update processor_driver to use .sys_notify
> >  ACPI: Update acpi_memhotplug to use .sys_notify
> >  ACPI: Update container to use .sys_notify
> > 
> > ---
> >  drivers/acpi/acpi_memhotplug.c  |   93 +-------------------------------------
> >  drivers/acpi/bus.c              |   64 ++++++++++++++++++++-------
> >  drivers/acpi/container.c        |   66 +--------------------------
> >  drivers/acpi/processor_driver.c |   82 +++-------------------------------
> >  drivers/acpi/scan.c             |   83 ++++++++++++++++++++++++++++++++++
> >  include/acpi/acpi_bus.h         |    6 +++
> >  6 files changed, 150 insertions(+), 244 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


