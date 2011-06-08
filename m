Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab1FHXNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:13:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39983 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab1FHXM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:12:58 -0400
Date: Wed, 8 Jun 2011 16:10:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Timur Tabi <timur@freescale.com>
Cc: <alan@lxorguk.ukuu.org.uk>, <arnd@arndb.de>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <cmetcalf@tilera.com>, <konrad.wilk@oracle.com>, <dsaxena@linaro.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
Message-Id: <20110608161009.7b05d305.randy.dunlap@oracle.com>
In-Reply-To: <1307573154-15838-1-git-send-email-timur@freescale.com>
References: <1307573154-15838-1-git-send-email-timur@freescale.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DF0015D.0087:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011 17:45:54 -0500 Timur Tabi wrote:

> Add the drivers/virt directory, which houses drivers that support
> virtualization environments, and add the Freescale hypervisor management
> driver.

It can't go in linux/virt or linux/virt/fsl instead?  why drivers/ ?

or maybe linux/virt should be drivers/virt ?


> The Freescale hypervisor management driver provides several services to
> drivers and applications related to the Freescale hypervisor:
> 
> 1. An ioctl interface for querying and managing partitions
> 
> 2. A file interface to reading incoming doorbells
> 
> 3. An interrupt handler for shutting down the partition upon receiving the
>    shutdown doorbell from a manager partition
> 
> 4. An interface for receiving callbacks when a managed partition shuts down.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>  drivers/Kconfig                |    2 +
>  drivers/Makefile               |    3 +
>  drivers/virt/Kconfig           |   22 +
>  drivers/virt/Makefile          |    5 +
>  drivers/virt/fsl_hypervisor.c  |  961 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/Kbuild           |    1 +
>  include/linux/fsl_hypervisor.h |  214 +++++++++
>  7 files changed, 1208 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/virt/Kconfig
>  create mode 100644 drivers/virt/Makefile
>  create mode 100644 drivers/virt/fsl_hypervisor.c
>  create mode 100644 include/linux/fsl_hypervisor.h


> diff --git a/include/linux/fsl_hypervisor.h b/include/linux/fsl_hypervisor.h
> new file mode 100644
> index 0000000..4d1e11a
> --- /dev/null
> +++ b/include/linux/fsl_hypervisor.h
> @@ -0,0 +1,214 @@
> +/*
> + * Freescale hypervisor ioctl interface
> + *
> + * Copyright (C) 2008-2011 Freescale Semiconductor, Inc.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Freescale Semiconductor nor the
> + *       names of its contributors may be used to endorse or promote products
> + *       derived from this software without specific prior written permission.
> + *
> + *
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") as published by the Free Software
> + * Foundation, either version 2 of that License or (at your option) any
> + * later version.

Why any later version?  I thought that <powers> decided that Linux
is GPL v2.

> + *
> + * This software is provided by Freescale Semiconductor "as is" and any
> + * express or implied warranties, including, but not limited to, the implied
> + * warranties of merchantability and fitness for a particular purpose are
> + * disclaimed. In no event shall Freescale Semiconductor be liable for any
> + * direct, indirect, incidental, special, exemplary, or consequential damages
> + * (including, but not limited to, procurement of substitute goods or services;
> + * loss of use, data, or profits; or business interruption) however caused and
> + * on any theory of liability, whether in contract, strict liability, or tort
> + * (including negligence or otherwise) arising in any way out of the use of this
> + * software, even if advised of the possibility of such damage.
> + *
> + * This file is used by the Freescale hypervisor management driver.  It can
> + * also be included by applications that need to communicate with the driver
> + * via the ioctl interface.
> + */
> +
> +#ifndef FSL_HYPERVISOR_H
> +#define FSL_HYPERVISOR_H
> +
> +#include <linux/types.h>
> +
> +/**
> + * struct fsl_hv_ioctl_restart: restart a partition

This syntax should be (for all structs here):

 * struct fsl_hv_ioctl_restart - restart a partition

but the struct fields/members do use ':' instead of '-'.

Darn, I checked Documentation/kernel-doc-nano-HOWTO.txt and it says
that ':' is optional but '-' is needed, so you could use

 * struct fsl_hv_ioctl_restart: - restart a partition

> + * @ret: return error code from the hypervisor
> + * @partition: the ID of the partition to restart, or -1 for the
> + *             calling partition
> + *
> + * Used by FSL_HV_IOCTL_PARTITION_RESTART
> + */
> +struct fsl_hv_ioctl_restart {
> +	__u32 ret;
> +	__u32 partition;
> +};
> +
> +/**
> + * struct fsl_hv_ioctl_status: get a partition's status
> + * @ret: return error code from the hypervisor
> + * @partition: the ID of the partition to query, or -1 for the
> + *             calling partition
> + * @status: The returned status of the partition
> + *
> + * Used by FSL_HV_IOCTL_PARTITION_GET_STATUS
> + *
> + * Values of 'status':
> + *    0 = Stopped
> + *    1 = Running
> + *    2 = Starting
> + *    3 = Stopping
> + */
> +struct fsl_hv_ioctl_status {
> +	__u32 ret;
> +	__u32 partition;
> +	__u32 status;
> +};
> +
> +/**
> + * struct fsl_hv_ioctl_start: start a partition
> + * @ret: return error code from the hypervisor
> + * @partition: the ID of the partition to control
> + * @entry_point: The offset within the guest IMA to start execution
> + * @load: If non-zero, reload the partition's images before starting
> + *
> + * Used by FSL_HV_IOCTL_PARTITION_START
> + */
> +struct fsl_hv_ioctl_start {
> +	__u32 ret;
> +	__u32 partition;
> +	__u32 entry_point;
> +	__u32 load;
> +};
> +
> +/**
> + * struct fsl_hv_ioctl_stop: stop a partition
> + * @ret: return error code from the hypervisor
> + * @partition: the ID of the partition to stop, or -1 for the calling
> + *             partition
> + *
> + * Used by FSL_HV_IOCTL_PARTITION_STOP
> + */
> +struct fsl_hv_ioctl_stop {
> +	__u32 ret;
> +	__u32 partition;
> +};
> +
> +/**
> + * struct fsl_hv_ioctl_memcpy: copy memory between partitions
> + * @ret: return error code from the hypervisor
> + * @source: the partition ID of the source partition, or -1 for this
> + *          partition
> + * @target: the partition ID of the target partition, or -1 for this
> + *          partition
> + * @local_addr: user-space virtual address of a buffer in the local
> + *              partition
> + * @remote_addr: guest physical address of a buffer in the
> + *           remote partition
> + * @count: the number of bytes to copy.  Both the local and remote
> + *         buffers must be at least 'count' bytes long
> + *
> + * Used by FSL_HV_IOCTL_MEMCPY
> + *
> + * The 'local' partition is the partition that calls this ioctl.  The
> + * 'remote' partition is a different partition.  The data is copied from
> + * the 'source' paritition' to the 'target' partition.
> + *
> + * The buffer in the remote partition must be guest physically
> + * contiguous.
> + *
> + * This ioctl does not support copying memory between two remote
> + * partitions or within the same partition, so either 'source' or
> + * 'target' (but not both) must be -1.  In other words, either
> + *
> + *      source == local and target == remote
> + * or
> + *      source == remote and target == local
> + */
> +struct fsl_hv_ioctl_memcpy {
> +	__u32 ret;
> +	__u32 source;
> +	__u32 target;
> +	__u64 local_vaddr;
> +	__u64 remote_paddr;
> +	__u64 count;
> +};
> +
> +/**
> + * struct fsl_hv_ioctl_doorbell: ring a doorbell
> + * @ret: return error code from the hypervisor
> + * @doorbell: the handle of the doorbell to ring doorbell
> + *
> + * Used by FSL_HV_IOCTL_DOORBELL
> + */
> +struct fsl_hv_ioctl_doorbell {
> +	__u32 ret;
> +	__u32 doorbell;
> +};
> +
> +/**
> + * struct fsl_hv_ioctl_prop: get/set a device tree property
> + * @ret: return error code from the hypervisor
> + * @handle: handle of partition whose tree to access
> + * @path: virtual address of path name of node to access
> + * @propname: virtual address of name of property to access
> + * @propval: virtual address of property data buffer
> + * @proplen: Size of property data buffer
> + *
> + * Used by FSL_HV_IOCTL_DOORBELL
> + */
> +struct fsl_hv_ioctl_prop {
> +	__u32 ret;
> +	__u32 handle;
> +	__u64 path;
> +	__u64 propname;
> +	__u64 propval;
> +	__u32 proplen;
> +};
> +
> +/*
> + * ioctl commands.
> + */
> +enum {
> +	FSL_HV_IOCTL_PARTITION_RESTART = 1, /* Boot another partition */
> +	FSL_HV_IOCTL_PARTITION_GET_STATUS = 2, /* Boot another partition */
> +	FSL_HV_IOCTL_PARTITION_START = 3, /* Boot another partition */
> +	FSL_HV_IOCTL_PARTITION_STOP = 4, /* Stop this or another partition */
> +	FSL_HV_IOCTL_MEMCPY = 5, /* Copy data from one partition to another */
> +	FSL_HV_IOCTL_DOORBELL = 6, /* Ring a doorbell */
> +
> +	/* Get a property from another guest's device tree */
> +	FSL_HV_IOCTL_GETPROP = 7,
> +
> +	/* Set a property in another guest's device tree */
> +	FSL_HV_IOCTL_SETPROP = 8,
> +};
> +
> +#ifdef __KERNEL__
> +
> +/**
> + * fsl_hv_event_register -- register a callback for failover events

Documentation/kernel-doc-nano-HOWTO.txt says to use one '-' here, not 2.

> + *
> + * This function is called by device drivers to register their callback
> + * functions for fail-over events.
> + */
> +int fsl_hv_failover_register(struct notifier_block *nb);
> +
> +/**
> + * fsl_hv_event_unregister -- unregister a callback for failover events

ditto.
And function arg descriptions are missing for both of these functions.

> + */
> +int fsl_hv_failover_unregister(struct notifier_block *nb);
> +
> +#endif
> +
> +#endif
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
