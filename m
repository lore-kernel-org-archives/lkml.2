Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1CGWYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:24:42 -0500
Received: from kroah.org ([198.145.64.141]:45145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab1CGWYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:24:41 -0500
Date: Mon, 7 Mar 2011 14:23:56 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 00/16] Staging: hv: Consolidate driver and device
 abstractions
Message-ID: <20110307222356.GA25714@kroah.com>
References: <1299531695-22352-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299531695-22352-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 01:01:35PM -0800, K. Y. Srinivasan wrote:
> Hyper-V has maintained both its class independent driver and 
> device state in two independent data structures:
> Driver state: struct driver_context (vmbus.h) and struct hv_driver
> (vmbus_api.h)
> Device state: struct vm_device (vmbus.h) and struct hv_device (vmbus_api.h)
> 
> While sruct driver_context and struct vm_device embed generic 
> Linux abstractions of struct device_driver and struct device respectively; 
> the lower level hyperv abstraction: struct hv_driver and struct hv_device
> have maintained state needed to communicate with the host. This partitioning
> made sense at a point in time when it was not clear how much of 
> the hypervisor interaction would be open sourced. Given where we are
> today, there is no reason to keep this layering. This patchset 
> consolidates all the driver state into a single structure: 
> struct hv_driver while all the device state is consolidated into
> a single structure: struct hv_device. This consolidation simplifies
> the code while simultaneously getting rid of redundant state -
> for instance in the current code, both struct driver_context and
> struct hv_driver both have state to represent the class as well as
> instance id. We do this consolidation by moving state from higher
> level structures (struct driver_context and struct vm_device) to
> lower level structures (struct hv_driver and hv_device) respectively.
> 
> While it has not been a goal of this effort to cleanup structure and 
> variable names, this consolidation effort has resulted in some cleanup
> with regards to structure and variable names: a) Some of the badly
> named structures have been eliminated (struct driver_context etc.) 
> while hopefully all newly introduced names are acceptable.  
> 
> Patches 1 through 11 deal with consolidating the device driver
> state while patches 12 through 16  deal with consolidating
> device state.

Very nice job, now that's the way to break up and send a patch series.

I've queued them all up now.

I'm guessing that you will have follow-on patches now to complete the
migration to the correct driver core use (i.e. proper driver and device
usage?)  Or do you want me to look into doing this?

thanks,

greg k-h
