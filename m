Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2G0RUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:20:45 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55682 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab2G0RUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:20:44 -0400
Date: Fri, 27 Jul 2012 10:20:43 -0700 (PDT)
From: Andrew Stiegmann <astiegmann@vmware.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com,
        gregkh@linuxfoundation.org
Message-ID: <1693394101.5749000.1343409643934.JavaMail.root@vmware.com>
In-Reply-To: <20120727103455.GA4639@merkur.ravnborg.org>
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

----- Original Message -----
> From: "Sam Ravnborg" <sam@ravnborg.org>
> To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
> Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
> vm-crosstalk@vmware.com, cschamp@vmware.com, gregkh@linuxfoundation.org
> Sent: Friday, July 27, 2012 3:34:55 AM
> Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
> 
> Hi Andrew.
> 
> A few things noted in the following..
> 
> > 
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 2661f6e..fe38c7a 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -517,4 +517,5 @@ source "drivers/misc/lis3lv02d/Kconfig"
> >  source "drivers/misc/carma/Kconfig"
> >  source "drivers/misc/altera-stapl/Kconfig"
> >  source "drivers/misc/mei/Kconfig"
> > +source "drivers/misc/vmw_vmci/Kconfig"
> >  endmenu
> > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> > index 456972f..af9e413 100644
> > --- a/drivers/misc/Makefile
> > +++ b/drivers/misc/Makefile
> > @@ -51,3 +51,4 @@ obj-y				+= carma/
> >  obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
> >  obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
> >  obj-$(CONFIG_INTEL_MEI)		+= mei/
> > +obj-y				+= vmw_vmci/
> 
> Please use obj-$(CONFIG_VMWARE_VMCI) += vmw_vmci/
> 
> like we do in the other cases. This prevents us from visiting the
> directory
> when this feature is not enabled.

Ok.

> > +++ b/drivers/misc/vmw_vmci/Makefile
> > @@ -0,0 +1,43 @@
> > +################################################################################
> > +#
> > +# Linux driver for VMware's VMCI device.
> > +#
> > +# Copyright (C) 2007-2012, VMware, Inc. All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > modify it
> > +# under the terms of the GNU General Public License as published
> > by the
> > +# Free Software Foundation; version 2 of the License and no later
> > version.
> > +#
> > +# This program is distributed in the hope that it will be useful,
> > but
> > +# WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE
> > or
> > +# NON INFRINGEMENT.  See the GNU General Public License for more
> > +# details.
> > +#
> > +# You should have received a copy of the GNU General Public
> > License
> > +# along with this program; if not, write to the Free Software
> > +# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> > 02110-1301 USA.
> > +#
> > +# The full GNU General Public License is included in this
> > distribution in
> > +# the file called "COPYING".
> > +#
> > +# Maintained by: Andrew Stiegmann <pv-drivers@vmware.com>
> > +#
> > +################################################################################
> Lot's of boilerplate noise for such a simple file...

I removed the section containing FSF address and section below it as well per Greg KH's request.

> > +
> > +#
> > +# Makefile for the VMware VMCI
> > +#
> > +
> > +obj-$(CONFIG_VMWARE_VMCI) += vmw_vmci.o
> > +
> > +vmw_vmci-objs += vmci_context.o
> > +vmw_vmci-objs += vmci_datagram.o
> > +vmw_vmci-objs += vmci_doorbell.o
> > +vmw_vmci-objs += vmci_driver.o
> > +vmw_vmci-objs += vmci_event.o
> > +vmw_vmci-objs += vmci_handle_array.o
> > +vmw_vmci-objs += vmci_hash_table.o
> > +vmw_vmci-objs += vmci_queue_pair.o
> > +vmw_vmci-objs += vmci_resource.o
> > +vmw_vmci-objs += vmci_route.o
> 
> please use:
> vmw_vmci-y += vmci_context.o
> vmw_vmci-y += vmci_datagram.o
> vmw_vmci-y += vmci_doorbell.o
> 
> This is recommended these days and allows you to enable/disable
> single files later using a config option.

Ok.
 
> > diff --git a/drivers/misc/vmw_vmci/vmci_common_int.h
> > b/drivers/misc/vmw_vmci/vmci_common_int.h
> > +
> > +#ifndef _VMCI_COMMONINT_H_
> > +#define _VMCI_COMMONINT_H_
> > +
> > +#include <linux/printk.h>
> > +#include <linux/vmw_vmci_defs.h>
> 
> Use inverse chrismas tree here.
> Longer include lines first, and soret alphabetically when
> lines are of the same length.
> This applies likely in many cases.
> 
> > +#include "vmci_handle_array.h"
> > +
> > +#define ASSERT(cond) BUG_ON(!(cond))
> > +
> > +#define CAN_BLOCK(_f) (!((_f) & VMCI_QPFLAG_NONBLOCK))
> > +#define QP_PINNED(_f) ((_f) & VMCI_QPFLAG_PINNED)
> 
> Looks like poor obscufation.
> Use a statis inline function if you need a helper for this.

These definitions are intended more as a helper to make reading the code easier.  IMHO ts a lot easier to read

if (CAN_BLOCK(flags))

compared to 

if (!(flags & VMCI_QPFLAG_NONBLOCK))

Wouldn't you agree?  I'm not sure something this simple warrants a static inline function but I don't see any harm in converting it over to that.
 
> > +
> > +/*
> > + * Utilility function that checks whether two entities are allowed
> > + * to interact. If one of them is restricted, the other one must
> > + * be trusted.
> > + */
> > +static inline bool vmci_deny_interaction(uint32_t partOne,
> > +					 uint32_t partTwo)
> 
> The kernel types are u32 not uint32_t - these types belongs in
> user-space.

Ok.

> > +++ b/include/linux/vmw_vmci_api.h
> > +
> > +#ifndef __VMW_VMCI_API_H__
> > +#define __VMW_VMCI_API_H__
> > +
> > +#include <linux/vmw_vmci_defs.h>
> > +
> > +#undef  VMCI_KERNEL_API_VERSION
> > +#define VMCI_KERNEL_API_VERSION_2 2
> > +#define VMCI_KERNEL_API_VERSION   VMCI_KERNEL_API_VERSION_2
> > +
> > +typedef void (VMCI_DeviceShutdownFn) (void *deviceRegistration,
> > void *userData);
> > +
> > +bool VMCI_DeviceGet(uint32_t *apiVersion,
> > +		    VMCI_DeviceShutdownFn *deviceShutdownCB,
> > +		    void *userData, void **deviceRegistration);
> 
> The kernel style is to use lower_case for everything.
> So this would become:
> 
>     vmci_device_get()
> 
> This is obviously a very general comment and applies everywhere.

I wish I could lower case these symbols but VMCI has already existed outside the mainline Linux tree for some time now and changing these exported symbols would mean that other drivers that depend on VMCI (vSock, vmhgfs) would need to change as well.   One thought that did come to mind was exporting both VMCI_Device_Get and vmci_device_get but that would likely just confuse people.  So in short I have made function names lower case where possible, but exported symbols could not be changed.

> 	Sam
> 
