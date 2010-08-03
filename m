Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0HCSub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:50:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:46063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab0HCSu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:50:28 -0400
Date: Tue, 3 Aug 2010 11:43:13 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops (resubmit)
Message-ID: <20100803184312.GA6150@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7280E8556B@TK5EX14MBXC121.redmond.corp.microsoft.com>
 <20100803013013.GC3814@kroah.com>
 <1FB5E1D5CA062146B38059374562DF728380C2F4@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF728380C2F4@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 06:21:50PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Monday, August 02, 2010 9:30 PM
> > Why put the subject in the body of the email?  This forces me to edit
> > it again :(
> 
> Sure, I'll remove it.

thanks.

> > > functions. We need to put them into net_device_ops. For example,
> > > eth_change_mtu prevents setting MTU beyond 1500. This is necessary
> > > because we don't support jumbo frame at this time.
> > 
> > What does this mean?  Is it a bug?  Just not going as fast as possible?
> > Something else?
> 
> Yes, it's a bug when porting Linux IC from 2.6.27 to 2.6.32. In 2.6.27,
> the default functions for Ethernet, like eth_change_mtu(), were assigned
> by ether_setup(). But in 2.6.32, these function pointers moved to
> net_device_ops structure and no longer be assigned in ether_setup(). So we
> need to set these functions in our driver code. It will ensure the MTU won't
> be set beyong 1500. Otherwise, this can cause an error on the server side,
> because the HyperV linux driver doesn't support jumbo frame yet.

Wonderful, why not put this type of full information in the patch itself
so that people can understand and rememeber what is going on when they
look at it in a few months time?

> > >   It affects kernel 2.6.32 and later, which are all versions
> > > containing Hyper-V drivers.
> > 
> > So is this fixing a bug that needs to be backported to these older
> > kernels (i.e. the staging tree?)  Is this something that is causing
> > people problems?
> 
> Yes it should be backported. The bug can cause error on guest and host.

Than please ask for it to be backported in the future.

thanks,

greg k-h
