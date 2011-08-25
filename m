Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1HYSP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:15:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1HYSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:15:26 -0400
Date: Thu, 25 Aug 2011 21:16:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Broken pci_block_user_cfg_access interface
Message-ID: <20110825181613.GA27183@redhat.com>
References: <4E54D5D7.8050807@siemens.com>
 <4E551298.2000302@linux.vnet.ibm.com>
 <4E5613BA.5070101@siemens.com>
 <20110825094031.GA3727@redhat.com>
 <4E5648EB.5030302@linux.vnet.ibm.com>
 <4E564A45.2040300@linux.vnet.ibm.com>
 <4E564B1D.2090201@siemens.com>
 <4E564CF9.5070209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E564CF9.5070209@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 08:24:09AM -0500, Brian King wrote:
> > Is this broken ATM? I thought the PCI core would simply try all methods
> > + has a quirks section for completely funky devices.
> 
> Yes. Its certainly broken for ipr. If the ipr driver is loaded, it really needs
> to be the one doing the reset. If its not loaded, I may need to add a few
> quirks for these adapters to properly handle this function.
> 
> -Brian

Driving reset through sysfs while another driver is bound
is likely broken for many types of devices.
But so it writing config space through sysfs,
or accessing BARs by mmap while a kernel driver is bound
with the exception of simple stub drivers such as uio and pci-stub.
And no amount of locking can fix that I think.

Let's try to see whether there's an issue with
existing applications, all of which IIUC
have a single userspace driver accessing the device.

Besides that, all we need to address, as I see it,
is not making things worse: that is if device potentially
gets broken by a sysfs access, we can't help this,
but let's at least not trigger BUG errors.

-- 
MST
