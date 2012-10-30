Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2J3CZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:25:13 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33724 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2J3CZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:25:10 -0400
Date: Mon, 29 Oct 2012 19:26:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 05/12] VMCI: event handling implementation.
Message-ID: <20121030022605.GG1920@kroah.com>
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
> +static void event_signal_destroy(struct kref *kref)
> +{
> +	struct vmci_subscription *entry =
> +			container_of(kref, struct vmci_subscription, kref);
> +
> +	complete(&entry->done);
> +}

Didn't you just leak memory here?  What frees the structure up?

thanks,

greg k-h
