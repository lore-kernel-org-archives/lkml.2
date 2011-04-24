Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1DXQS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 12:18:28 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:46915 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab1DXQSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 12:18:25 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: Hyper-V vmbus driver
Thread-Topic: Hyper-V vmbus driver
Thread-Index: Acv4dbOc5a5M0q/iSFeqdVfCMBGUlgAQJ/0AAlOYtIAAIPMtoA==
Date: Sun, 24 Apr 2011 16:18:24 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481D3562@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <6E21E5352C11B742B20C142EB499E0481C8D35@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110411190708.GA21355@suse.de> <20110423152055.GA29109@kroah.com>
In-Reply-To: <20110423152055.GA29109@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Saturday, April 23, 2011 11:21 AM
> To: Greg KH
> Cc: KY Srinivasan; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> virtualization@lists.osdl.org
> Subject: Re: Hyper-V vmbus driver
> 
> On Mon, Apr 11, 2011 at 12:07:08PM -0700, Greg KH wrote:
> 
> Due to other external issues, my patch backlog is still not gotten
> through yet, sorry.  Sometimes "real life" intrudes on the best of
> plans.
> 
> I'll get to this when I get through the rest of your hv patches, and the
> other patches pending that I have in my queues.

Thanks Greg. The latest re-send of my hv patches are against the tree:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git
that I picked up on April 22, 2011.  I hope there won't be any issues
this time around.

> 
> But, I would recommend you going through and looking at the code and
> verifying that you feel the bus code is "ready".  At a very quick
> glance, you should not have individual drivers have to set their 'struct
> device' pointers directly, that is something that the bus does, not the
> driver.  The driver core will call your bus and your bus will then do
> the matching and call the probe function of the driver if needed.

Are you referring to the fact that in the vmbus_match function,
the current code binds the device specific driver to the
corresponding hv_device structure?
 
> 
> See the PCI driver structure for an example of this if you are curious.
> It should also allow you to get rid of that unneeded *priv pointer in
> the struct hv_driver.

I am pretty sure, I can get rid of this. The way this code was originally
structured, in the vmbus_match() function, you needed to get at the
device specific driver pointer so that we could do the binding between
the hv_device and the correspond device specific driver. The earlier code 
depended on the structure layout to map a pointer to the hv_driver to
the corresponding device specific driver (net, block etc.) To get rid of 
this layout dependency, I introduced an addition field (priv) in the hv_driver.

There is, I suspect sufficient state available to:

(a) Not require the vmbus_match() function to do the binding.
(b) And to get at the device specific driver structure from the generic
       driver structure without having to have an explicit mapping 
       maintained in the   hv_driver structure.

Before, I go ahead and make these changes, Greg, can you confirm
if I have captured your concerns correctly.

>  You should be able to set that structure
> constant, like all other busses.  Right now you can not which shows a
> design issue.

I am a little confused here. While I agree with you that perhaps we could
get rid the priv element in the hv_driver structure, what else would you 
want done here. 

> 
> So, take a look at that and let me know what you think.

Once I hear from you, I will work on getting rid of the 
priv pointer from hv_driver structure as well as the code that 
currently does the binding in vmbus_match. 

Regards,

K. Y

