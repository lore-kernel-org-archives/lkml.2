Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2J3CG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:06:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51297 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2J3CG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:06:58 -0400
Date: Mon, 29 Oct 2012 19:07:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 01/12] VMCI: context implementation.
Message-ID: <20121030020752.GA1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010333.17788.94988.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010333.17788.94988.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:03:42PM -0700, George Zhang wrote:
> VMCI Context code maintains state for vmci and allows the driver to communicate with multiple VMs.
> 

Very minor nit, wrap your changelog comments at 72 columns or at the
least, 80.  Didn't checkpatch complain about that?

> +/*
> + * vmci_context_id_to_host_vmid() - Map CID to HostID
> + * @context_id: Context ID of VMCI context.
> + * @host_vmid:  Host VM ID data
> + * @host_vmid_len:      Length of Host VM ID Data.
> + *
> + * Maps a context ID to the host specific (process/world) ID
> + * of the VM/VMX.  This function is not used on Linux systems
> + * and should be ignored.
> + */
> +int vmci_context_id_to_host_vmid(u32 context_id,
> +				 void *host_vmid, size_t host_vmid_len)
> +{
> +	return VMCI_ERROR_UNAVAILABLE;
> +}
> +EXPORT_SYMBOL_GPL(vmci_context_id_to_host_vmid);

Why even have this function if it doesn't do anything?


thanks,

greg k-h
