Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0GNRVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:21:19 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:23575 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab0GNRVR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:21:17 -0400
From: Pankaj Thakkar <pthakkar@vmware.com>
To: Greg KH <greg@kroah.com>, Shreyas Bhatewara <sbhatewara@vmware.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 14 Jul 2010 10:18:22 -0700
Subject: RE: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Thread-Topic: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Thread-Index: AcsjOc9rOplIY5g0T3aQ3R9ceXoDTQAPsB7X
Message-ID: <F1354E79A137A24CBA60059AA65CB1B802A34EEB67@EXCH-MBX-2.vmware.com>
References: <20100504230225.GP8323@vmware.com>
 <201005051029.42052.dtor@vmware.com> <20100505173120.GA1752@infradead.org>
 <201005051035.29831.dtor@vmware.com> <20100505173951.GA8388@infradead.org>
 <20100505105253.0a8bc465@nehalam> <20100506202113.GC17922@infradead.org>
 <1278990388.32650.22.camel@eng-rhel5-64>,<20100714094952.GA16209@kroah.com>
In-Reply-To: <20100714094952.GA16209@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The plugin is guest agnostic and hence we did not want to rely on any kernel provided functions. The plugin uses only the interface provided by the shell. The assumption is that since the plugin is really simple and straight forward (all the control/init complexity lies in the PF driver in the hypervisor) we should be able to get by for most of the things and for things like memcpy/memset the plugin can write simple functions like this.


-p


________________________________________
From: Greg KH [greg@kroah.com]
Sent: Wednesday, July 14, 2010 2:49 AM
To: Shreyas Bhatewara
Cc: Christoph Hellwig; Stephen Hemminger; Pankaj Thakkar; pv-drivers@vmware.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3


Is there some reason that our in-kernel functions that do this type of
logic are not working for you to require you to reimplement this?

thanks,

greg k-h