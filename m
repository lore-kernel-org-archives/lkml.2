Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1IPK5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 06:57:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40044 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1IPK5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:57:22 -0400
Date: Fri, 16 Sep 2011 06:57:16 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v2)
Message-ID: <20110916105716.GA32672@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316117318-22027-1-git-send-email-nhorman@tuxdriver.com>
 <20110916083646.GA30915@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916083646.GA30915@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.2 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 10:36:46AM +0200, Greg KH wrote:
> On Thu, Sep 15, 2011 at 04:08:38PM -0400, Neil Horman wrote:
> > +static struct kobj_type msi_irq_ktype = {
> > +	.sysfs_ops = &msi_irq_sysfs_ops,
> > +	.default_attrs = msi_irq_default_attrs,
> > +};
> 
> You still haven't successfully removed the kobject associated with this
> kobj_type.  Otherwise you would have seen the error messages in the
> kernel log and fixed up what it told you to fix.
> 
> Please do so.
> 
Well, I'm not using kobject_del, you're right, I'm just using a kobject_put, and
I swear I'm not getting any error messages about it:
[root@amd-dinar-01 eth0]# echo 1 > ./device/remove
[root@amd-dinar-01 eth0]# dmesg | tasil -10
[   17.673050] RPC: Registered tcp transport module.
[   17.677759] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   17.702913] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses
genfs_contexts
[   20.060280] bnx2 0000:01:00.0: eth0: NIC Copper Link is Up, 1000 Mbps full
duplex
[   20.070903] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.106296] bnx2 0000:01:00.1: eth1: NIC Copper Link is Up, 1000 Mbps full
duplex
[   20.116857] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   30.850059] eth1: no IPv6 routers present

I'm not sure why that would be, but theres definately no warning about it.
Either way, I'll gladly make the change to use kobject_del

Regards
Neil

