Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab2JYT2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:28:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39446 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2JYT2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:28:54 -0400
Date: Thu, 25 Oct 2012 12:28:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com
Subject: Re: [PATCH 04/10] VMCI: device driver implementaton.
Message-ID: <20121025192851.GA26627@kroah.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121016002832.26205.60696.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016002832.26205.60696.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 05:28:47PM -0700, George Zhang wrote:
> +/*
> + * vmci_device_get() - Checks for VMCI device.
> + * @api_version:        The API version to use
> + * @device_shutdown_cb: Callback used when shutdown happens (Unused)
> + * @user_data:  Data to be passed to the callback (Unused)
> + * @device_registration:        A device registration handle. (Unused)
> + *
> + * Verifies that a valid VMCI device is present, and indicates
> + * the callers intention to use the device until it calls
> + * vmci_device_release().
> + */
> +bool vmci_device_get(u32 *api_version,
> +		     vmci_device_shutdown_fn *device_shutdown_cb,
> +		     void *user_data, void **device_registration)
> +{
> +	if (*api_version > VMCI_KERNEL_API_VERSION) {
> +		*api_version = VMCI_KERNEL_API_VERSION;
> +		return false;
> +	}
> +
> +	return drv_device_enabled();
> +}
> +EXPORT_SYMBOL(vmci_device_get);

EXPORT_SYMBOL_GPL() for this, and all other exports?

And it seems that you have a bunch of "unused" parameters for this, and
other public functions.  Please just remove them entirely, otherwise it
just confuses reviewers, and anyone who wants to write code to interface
with the code.  You can always add parameters at a later point in time
if you find that you really need them.

thanks,

greg k-h
