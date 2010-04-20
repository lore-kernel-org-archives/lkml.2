Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0DTQbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:31:37 -0400
Received: from kroah.org ([198.145.64.141]:48235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab0DTQbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:31:35 -0400
Date: Tue, 20 Apr 2010 09:32:15 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pci_get_dev_by_id() from interrupt handlers
Message-ID: <20100420163215.GB3270@kroah.com>
References: <20100420160423.GD31537@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420160423.GD31537@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:04:24PM +0200, Joerg Roedel wrote:
> Hi Jesse,
> 
> I have a question regarding the warning in the pci_get_dev_by_id()
> [search.c] function which triggers when called from interrupt context.
> As far as I have seen this function should be save to be called in
> atomic mode.

Are you sure?

> Is there any other reason it should not be called in interrupt
> handlers?

klist traversal is not safe to be done in interrupt context as the
spinlock is not told to be interrupt safe.  Now you could go and change
the klist core to be interrupt safe, but you should probably rethink
your need here first.

> I need to (indirectly) call this function for my IOMMU driver to
> handle events from the IOMMU.

>From interrupt?  Why not use an interrupt thread instead if you really
need to do this.

Actually, what are you trying to accomplish here?

thanks,

greg k-h
