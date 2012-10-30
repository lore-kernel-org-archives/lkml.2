Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2J3CUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:20:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51211 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2J3CUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:20:49 -0400
Date: Mon, 29 Oct 2012 19:21:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 04/12] VMCI: device driver implementaton.
Message-ID: <20121030022143.GD1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010409.17788.6745.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010409.17788.6745.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:04:15PM -0700, George Zhang wrote:
> +/*
> + * vmci_get_context_id() - Gets the current context ID.
> + *
> + * Returns the current context ID.  Note that since this is accessed only
> + * from code running in the host, this always returns the host context ID.
> + */
> +u32 vmci_get_context_id(void)
> +{
> +	if (vmci_guest_code_active()) {
> +		return vmci_get_vm_context_id();
> +	} else if (vmci_host_code_active()) {
> +		return VMCI_HOST_CONTEXT_ID;
> +	} else {
> +		return VMCI_INVALID_ID;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(vmci_get_context_id);

checkpatch didn't complain about too many { } here?

> +/*
> + * vmci_version() - Returns the version of the driver.
> + *
> + * Returns the version of the VMCI driver.
> + */
> +u32 vmci_version(void)
> +{
> +	return VMCI_VERSION;
> +}
> +EXPORT_SYMBOL_GPL(vmci_version);

Why is this needed?  Why would a kernel driver ever care about this?

thanks,

greg k-h
