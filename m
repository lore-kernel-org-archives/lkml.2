Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0HCSV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:21:57 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:15779 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab0HCSVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:21:55 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops (resubmit)
Thread-Topic: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops (resubmit)
Thread-Index: AQHLMmqUZKh2eb7ENEOe42IZNUMKnZLPZ1sAgACg9MA=
Date: Tue, 3 Aug 2010 18:21:50 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF728380C2F4@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7280E8556B@TK5EX14MBXC121.redmond.corp.microsoft.com>
 <20100803013013.GC3814@kroah.com>
In-Reply-To: <20100803013013.GC3814@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, August 02, 2010 9:30 PM
> Why put the subject in the body of the email?  This forces me to edit
> it again :(

Sure, I'll remove it.

> > functions. We need to put them into net_device_ops. For example,
> > eth_change_mtu prevents setting MTU beyond 1500. This is necessary
> > because we don't support jumbo frame at this time.
> 
> What does this mean?  Is it a bug?  Just not going as fast as possible?
> Something else?

Yes, it's a bug when porting Linux IC from 2.6.27 to 2.6.32. In 2.6.27,
the default functions for Ethernet, like eth_change_mtu(), were assigned
by ether_setup(). But in 2.6.32, these function pointers moved to
net_device_ops structure and no longer be assigned in ether_setup(). So we
need to set these functions in our driver code. It will ensure the MTU won't
be set beyong 1500. Otherwise, this can cause an error on the server side,
because the HyperV linux driver doesn't support jumbo frame yet.

> >   It affects kernel 2.6.32 and later, which are all versions
> > containing Hyper-V drivers.
> 
> So is this fixing a bug that needs to be backported to these older
> kernels (i.e. the staging tree?)  Is this something that is causing
> people problems?

Yes it should be backported. The bug can cause error on guest and host.

Thanks,

- Haiyang

