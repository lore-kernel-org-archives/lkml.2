Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2J3CcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:32:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2J3Cb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:31:59 -0400
Date: Mon, 29 Oct 2012 19:32:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 12/12] VMCI: Some header and config files.
Message-ID: <20121030023255.GJ1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010533.17788.79417.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010533.17788.79417.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:05:38PM -0700, George Zhang wrote:
> --- /dev/null
> +++ b/drivers/misc/vmw_vmci/Makefile
> @@ -0,0 +1,43 @@
> +################################################################################
> +#
> +# Linux driver for VMware's VMCI device.
> +#
> +# Copyright (C) 2007-2012, VMware, Inc. All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or modify it
> +# under the terms of the GNU General Public License as published by the
> +# Free Software Foundation; version 2 of the License and no later version.
> +#
> +# This program is distributed in the hope that it will be useful, but
> +# WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> +# NON INFRINGEMENT.  See the GNU General Public License for more
> +# details.
> +#
> +# Maintained by: Andrew Stiegmann <pv-drivers@vmware.com>
> +#
> +################################################################################

That's a big boiler-plate for a makefile :)

Wait, what's Andrew's name doing here, and yet it isn't on any of the
signed-off-by: or From: lines of the driver?  Surely you aren't the only
contributor here?

> +#
> +# Makefile for the VMware VMCI
> +#

That's the only needed comment for this file, if even that.

> +
> +obj-$(CONFIG_VMWARE_VMCI) += vmw_vmci.o
> +
> +vmw_vmci-y += vmci_context.o
> +vmw_vmci-y += vmci_datagram.o
> +vmw_vmci-y += vmci_doorbell.o
> +vmw_vmci-y += vmci_driver.o
> +vmw_vmci-y += vmci_event.o
> +vmw_vmci-y += vmci_guest.o
> +vmw_vmci-y += vmci_handle_array.o
> +vmw_vmci-y += vmci_host.o
> +vmw_vmci-y += vmci_queue_pair.o
> +vmw_vmci-y += vmci_resource.o
> +vmw_vmci-y += vmci_route.o

You can do this cleaner with multiple .o objects on the same line...

> +vmci:
> +	$(MAKE) -C ../../.. SUBDIRS=$$PWD CONFIG_VMWARE_VMCI=m modules
> +
> +clean:
> +	$(MAKE) -C ../../.. SUBDIRS=$$PWD CONFIG_VMWARE_VMCI=m clean

What are these two last targets for?  I'm guessing this is from when you
ported it from a stand-along module?  Please remove them.

greg k-h
