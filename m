Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1I2PDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:03:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1I2PC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:02:58 -0400
Date: Thu, 29 Sep 2011 07:51:26 -0700
From: Greg KH <gregkh@suse.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v4)
Message-ID: <20110929145126.GA3769@suse.de>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:38:49AM -0400, Neil Horman wrote:
> This patch adds a per-pci-device subdirectory in sysfs called:
> /sys/bus/pci/devices/<device>/msi_irqs
> 
> This sub-directory exports the set of msi vectors allocated by a given
> pci device, by creating a numbered sub-directory for each vector beneath
> msi_irqs.  For each vector various attributes can be exported.  Currently the
> only attribute is called mode, which tracks the operational mode of that vector
> (msi vs. msix)
> 
> ---
> 
> Change Notes:
> 
> (v2)
> Fixed up Documentation to put new sysfs interface descriptions in the right
> place, as per request by Greg K-H
> 
> Fixed up oops that resulted from removing pci device.  Not 100% sure I did this
> exactly right, but looking at the crash (triggered by echo 1 >
> /sys/class/net/eth0/device/remove), it looked as though we were freeing the
> pci_dev struct prior to all sysfs objects releasing their use of the device.  AS
> such it seemed most appropriate to hold references on the pci_dev for each msi
> irq sysfs object that we create, and release them on free accordingly.  With
> this change in place, I can remove, and add (via rescan) msi enabled devices
> ad-nauseum without a panic.  Again thanks to Greg K-H
> 
> (v3)
> As per Gregs suggestion, I looked further and noted that in fact, yes, it wasn't
> producing any errors on remove, but only because I had a refcounting problem,
> and my new sysfs objects were left orphaned with a dangling refcount.  I've
> fixed that, added a release method to the new ktype, which now drops the
> reference I hold on the pci_dev for us and I've validated that all objects I've
> created, along with the parent directory and pci device are cleaned up and freed
> by enabling the kobject dyanic_debug set and observing the appropriate release
> calls.  I can provide the logs if anyone wants to review them specifically.
> 
> (v4)
> Fixed up some spelling mistakes, and added a scissors line with a good
> commitlog, so that git-am drops all the version logging
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
