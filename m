Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2KOXrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:47:18 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49362 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2KOXrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:47:17 -0500
Date: Thu, 15 Nov 2012 15:47:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 02/12] VMCI: datagram implementation.
Message-ID: <20121115234714.GA8005@kroah.com>
References: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121107184116.9658.20579.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107184116.9658.20579.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 10:41:26AM -0800, George Zhang wrote:
> +/*
> + * Create a datagram entry given a handle pointer.
> + */
> +static int dg_create_handle(u32 resource_id,
> +			    u32 flags,
> +			    u32 priv_flags,
> +			    vmci_datagram_recv_cb recv_cb,
> +			    void *client_data, struct vmci_handle *out_handle)
> +{
> +	int result;
> +	u32 context_id;
> +	struct vmci_handle handle;
> +	struct datagram_entry *entry;
> +
> +	BUG_ON(!recv_cb);
> +	BUG_ON(!out_handle);
> +	BUG_ON(priv_flags & ~VMCI_PRIVILEGE_ALL_FLAGS);

Given that this is a static function, there's no need for these
"asserts", right?  Please send a follow-on patch removing all BUG_ON()
calls from these files, it's not acceptable to crash a user's box from a
driver that is handling parameters _you_ are feeding it.

thanks,

greg k-h
