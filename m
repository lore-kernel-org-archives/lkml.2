Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KPADf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:03:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35194 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2KPADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:03:34 -0500
Date: Thu, 15 Nov 2012 16:03:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 11/12] VMCI: host side driver implementation.
Message-ID: <20121116000331.GA13149@kroah.com>
References: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121107184249.9658.53806.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107184249.9658.53806.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 10:42:53AM -0800, George Zhang wrote:
> +/*
> + * Sets up a given context for notify to work.  Calls drv_map_bool_ptr()
> + * which maps the notify boolean in user VA in kernel space.
> + */
> +static int vmci_host_setup_notify(struct vmci_ctx *context,
> +				  unsigned long uva)
> +{
> +	struct page *page;
> +	int retval;
> +
> +	if (context->notify_page) {
> +		pr_devel("%s: Notify mechanism is already set up.\n", __func__);
> +		return VMCI_ERROR_DUPLICATE_ENTRY;
> +	}
> +
> +	if (!access_ok(VERIFY_WRITE, (void __user *)uva, sizeof(bool)))
> +		return VMCI_ERROR_GENERIC;

This line causes sparse to complain.  The odds that userspace knows what
gcc is using for "bool" is pretty low.

Please fix.

thanks,

greg k-h
