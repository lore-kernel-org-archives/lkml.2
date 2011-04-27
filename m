Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1D0ByG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:54:06 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:32094 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab1D0ByE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:54:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Topic: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Index: AQHMBGnbOdiUysHbTUGr026Sn7cwwZRw2pzQ
Date: Wed, 27 Apr 2011 01:54:02 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
In-Reply-To: <20110426232843.GA31184@kroah.com>
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
> Sent: Tuesday, April 26, 2011 7:29 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> 
> On Tue, Apr 26, 2011 at 09:19:45AM -0700, K. Y. Srinivasan wrote:
> > This patch-set addresses some of the bus/driver model cleanup that
> > Greg sugested over the last couple of days.  In this patch-set we
> > deal with the following issues:
> >
> > 	1) Cleanup unnecessary state in struct hv_device and
> > 	   struct hv_driver to be compliant with the Linux
> > 	   Driver model.
> >
> > 	2) Cleanup the vmbus_match() function to conform with the
> > 	   Linux Driver model.
> >
> > 	3) Cleanup error handling in the vmbus_probe() and
> > 	   vmbus_child_device_register() functions. Fixed a
> > 	   bug in the probe failure path as part of this cleanup.
> >
> > 	4) The Windows host cannot handle the vmbus_driver being
> > 	   unloaded and subsequently loaded. Cleanup the driver with
> > 	   this in mind.
> 
> I've stopped at this patch (well, I applied one more, but you can see
> that.)
> 
> I'd like to get some confirmation that this is really what you all want
> to do here before applying it.  If it is, care to resend them with a bit
> more information about this issue and why you all are making it?

Greg, this is restriction imposed by the Windows host:  you cannot reload the
Vmbus driver without rebooting the guest. If you cannot re-load, what good is it
to be able to unload? Distros that integrate these drivers will load these drivers 
automatically on boot and there is not much point in being able to unload this since 
most likely the root device will be handled by these drivers. For systems that don't
integrate these drivers; I don't see much point in allowing the driver to be unloaded,
if you cannot reload the driver without rebooting the guest. If and when the Windows 
host supports reloading the vmbus driver, we can very easily add this functionality.
The situation currently at best very misleading - you think you can unload the vmbus
driver, only to discover that you have to reboot the guest!

> 
> Anyway, other than this one, the series looks good.  But you should
> follow-up with some driver structure changes like what Christoph said to
> do. 

I will send you a patch for this.

> After that, do you want another round of review of the code, or do
> you have more things you want to send in (like the name[64] removal?)

I would prefer that we go through the  review process. What is the process for
this review? Is there a time window for people to respond. I am hoping I will be able
to address all the review comments well in advance of the  next closing of the tree,
with the hope of taking the vmbus driver out of staging this go around (hope springs
eternal in the human breast ...)! 

Regards,

K. Y
> 
> thanks,
> 
> greg k-h

