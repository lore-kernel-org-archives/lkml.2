Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1IVVLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:11:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:46149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1IVVLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,425,1312182000"; 
   d="scan'208";a="65507177"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <greg@kroah.com>
CC: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 23 Sep 2011 00:10:53 +0300
Subject: RE: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Topic: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Index: Acx5ZMP2APAqznoDQmibi/JUqKtGiQAAEE6A
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33EC@hasmsx504.ger.corp.intel.com>
References: <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
 <20110922183139.GA7217@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
 <20110922193805.GA8140@kroah.com> <20110922194310.GA8919@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33A3@hasmsx504.ger.corp.intel.com>
 <20110922195449.GA9433@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33C0@hasmsx504.ger.corp.intel.com>
 <20110922201805.GA13274@kroah.com>
In-Reply-To: <20110922201805.GA13274@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, September 22, 2011 11:18 PM
> To: Winkler, Tomas
> Cc: Weil, Oren jer; gregkh@suse.de; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
> 
> On Thu, Sep 22, 2011 at 11:11:38PM +0300, Winkler, Tomas wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Thursday, September 22, 2011 10:55 PM
> > > To: Winkler, Tomas
> > > Cc: Weil, Oren jer; gregkh@suse.de; devel@driverdev.osuosl.org;
> > > linux- kernel@vger.kernel.org
> > > Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done
> tasks.
> 
> Again, please fix your email client.
> 
> > > > Please start here
> > > > http://software.intel.com/en-us/blogs/2011/06/01/new-updated-intel
> > > > r-
> > > am
> > > > t-linux-drivers/
> > >
> > > That's a pointer to the same driver that is already in the kernel tree, right?
> > > What am I missing here?
> >
> > There is LMS there but I guess this links is more updated, they call it driver
> but actually it is a user space daemon.
> >
> > Anyhow this one should be the latest one
> > http://software.intel.com/en-us/articles/download-the-latest-intel-amt
> > -open-source-drivers/?wapkw=%28Linux+AMT%29
> > It also provides ACU.
> 
> What is "ACU"?
This is actually cli to work with ME,  all the docs can be found through that links.

I guess this is all quite complex, there is  Linux Enablement Guide on the link above it should be useful, 
yet we probably need to think to make something simple for reviewer also run the code in simple way...

> 
> Anyway, we want a good description of just what this driver is exporting to
> userspace, and how it is doing it.  That's the important part here, and is what
> we need to be able to properly review the code if you wish to start the
> process to move out of drivers/staging/

Yes I understand that and hoped we addressed that in mei.txt and patch0. 
Can you please comment directly on mei.txt what is not clear there or are you suggesting 
other form of documentation. We will also review it again and will address your ABI comments.

Briefly since this is all in mei.txt 

MEI provides nothing mere just a tunnel between user space and MEI firmware.
There are many features that MEI firmware can provide and each has its own rich API (we call it also protocol)
 The specific API documentation is available from link in the mei.txt (we need to fill the place holder actually)
The exceptions are Watchdog which is in kernel, talking to MEI firmware watchdog feature. Now it exposes standard
Watchdog Linux API, and AMTHI which just provides multiplexing between more than one user space application for AMTHI feature.

There is only one in/out ioctl  IOCTL_MEI_CONNECT_CLIENT, which after opening /dev/mei specifies which firmware feature we are going talk to.
Client is specified by UUID.  List of UUIDs is not part of the kernel API  (only the wd and amthi are visible in the code), this is up to the application to
to know what client it want to talk to it. 


Thanks
Tomas

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

