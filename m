Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1EDQ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:58:42 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:21970 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1EDQ6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:58:41 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: various vmbus review comments
Thread-Topic: various vmbus review comments
Thread-Index: AQHMCdM/6BBvI53KVEebJyh4jiWUR5R8ywQggACIZQD//4uZkA==
Date: Wed, 4 May 2011 16:58:39 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DFD6B@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
In-Reply-To: <20110504163228.GA19754@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, May 04, 2011 12:32 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: various vmbus review comments
> 
> On Wed, May 04, 2011 at 04:20:11PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Tuesday, May 03, 2011 4:47 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > > Subject: various vmbus review comments
> > >
> > > I just took a quick look at the vmbus code, and have the following
> >
> > I have currently consolidated all the header files as follows:
> >
> > 1) hyperv.h - this will have all the vmbus related definitions
> > needed to build drivers that attach to the bus (as you have suggested).
> 
> Great.
> 
> > 2) hyperv_storage.h - this has all the definitions needed to build storage
> > drivers for Hyper-V. Storage drivers will include hyperv.h and
> > hyperv_storage.h.
> >
> > 3) hyperv_net.h - this has all the definitions needed to build the network
> > driver for Hyper-V. The netvsc driver will include hyperv.h and hyperv_net.h.
> >
> > 4) hyperv_utils.h - this has all the definitions needed to build the util driver.
> > The util driver would include hyperv.h and hyperv_utils.h.
> 
> No for all 3 of these.  Why would a simple driver need a .h file at all?
> Just include the structures within the .c file, making it nice and
> self-contained.  There's no need to clutter things up, and individual
> driver .h files should _never_ be in include/linux.

Agreed - we don't need to clutter up  include/linux directory with individual
driver.h files. However, including all the definitions in the .c file would also be
ugly. For instance there are multiple *.c files for the storage drivers and we don't
want to replicate the contents of  hyperv_storage.h in each of these .c files.
The same is true for the netvsc driver - there are multiple .c files where we would need
to replicate the contents of hyperv_net.h. 

How about I keep these driver specific header files; but these could be local to the 
directory where these drivers land.
 
> >
> > > 	- the instances of hv_driver structures need to be static and
> > > 	  not programatically defined, like all other USB and PCI
> > > 	  drivers are handled.
> > > 	- module reference counting.  Are you sure you got it all right
> > > 	  for the individual modules that attach to the bus?  I don't
> > > 	  see any reference counting happening, is that correct?
> >
> > For this round, I want to concentrate on just the vmbus driver. So,
> > module reference counting is I don't think an issue for the vmbus driver
> > given that the driver is not unlodable. Once I am done with the vmbus driver
> > I will address the module reference counting issues for other drivers.
> 
> No, I am referring to the module reference counting of the bus drivers
> that register with the vmbus core.  You aren't doing that at all, and
> you probably need to make sure that this isn't needed.  That is
> concentrating on the vmbus driver.

Ok; I will look into this.

> 
> > I will also address your comment on static initialization hv_driver instances
> > as part of other driver cleanup.
> 
> No, please do this now as it will show how to properly interact with the
> vmbus core code in the correct manner.  Hopefully that will be correct,
> but I have a feeling that it will show you some places in the API that
> need to be changed...

Will do.

Regards,

K. Y

