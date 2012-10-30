Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2J3CXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:23:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53336 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2J3CXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:23:51 -0400
Date: Mon, 29 Oct 2012 19:24:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 05/12] VMCI: event handling implementation.
Message-ID: <20121030022446.GF1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010420.17788.59187.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010420.17788.59187.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:04:27PM -0700, George Zhang wrote:
> +/*
> + * Releases the given VMCISubscription.
> + * Fires the destroy event if the reference count has gone to zero.
> + */
> +static void event_release(struct vmci_subscription *entry)
> +{
> +	kref_put(&entry->kref, event_signal_destroy);
> +}

Same question as before with the kref_put() call, what is handling the
locking here?  It looks like a race to me.

thanks,

greg k-h
