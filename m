Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2KKFVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:21:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46042 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2KKFV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:21:27 -0500
Date: Sun, 11 Nov 2012 06:21:52 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [RFC PATCH 1/6] driver core: add a bus notification to
 temporarily reject driver binding
Message-ID: <20121111052152.GA5795@kroah.com>
References: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 09:57:14PM +0800, Jiang Liu wrote:
>  From: Jiang Liu <jiang.liu@huawei.com>
> 
> There are several requirements to temporarily reject device driver
> binding. Possible usage cases as below:
> 1) We should avoid binding an unsafe driver to a device belonging to
>    an active VFIO group, otherwise it will break the DMA isolation
>    property of VFIO.
> 2) When hot-removing a PCI hierachy, we should avoid binding device
>    drivers to PCI devices going to be removed during the window
>    between unbinding of device driver and destroying of device nodes.
> 3) When hot-adding a PCI host bridge, we should temporarily disable
>    driver binding before setting up corresponding IOMMU and IOAPIC.
> 
> We may add a flag into struct device to temporarily disable driver
> binding as in this thread https://patchwork.kernel.org/patch/1535721/.

I totally do not understand.  The bus controls this, if it does not want
to bind a device to a driver, then don't do it.  It's really quite
simple to just block the probe callback the bus gets, right?  Why create
all of this extra, and confusing, interface instead?

> This patch proposes another solution to temporarily disable driver
> binding by using bus notification mechanisms. It adds an notification
> event to solicit if anybody has objections when binding a driver to a
> device.

Sorry, but no, don't do this, it's way more confusing.

greg k-h
