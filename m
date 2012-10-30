Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2J3C2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:28:11 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38216 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2J3C2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:28:10 -0400
Date: Mon, 29 Oct 2012 19:29:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 08/12] VMCI: resource object implementation.
Message-ID: <20121030022905.GH1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010453.17788.90295.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010453.17788.90295.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:04:58PM -0700, George Zhang wrote:
> +static struct vmci_resource *vmci_resource_lookup(struct vmci_handle handle)
> +{
> +	struct vmci_resource *r, *resource = NULL;
> +	struct hlist_node *node;
> +	unsigned int idx = vmci_resource_hash(handle);
> +
> +	BUG_ON(VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE));

You just crashed a machine, with no chance for recovery.  Not a good
idea.  Never a good idea.  Customers just lost data, and now they are
mad.  Make sure you at least print out your email address so they know
who to blame :)

Seriously, never BUG() in a driver, warn, sure, but this just looks like
a debugging assert().  Please remove all of these, they are sprinkled
all over the driver code here, I'm only responding to one of them here.

Even better yet, properly handle the error and keep on going, that's
what the rest of the kernel does.  Or should :)

thanks,

greg k-h
