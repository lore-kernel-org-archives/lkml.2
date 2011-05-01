Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862Ab1EAS5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:57:00 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:6822 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab1EAS47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:56:59 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Topic: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Index: AQHMBGnbOdiUysHbTUGr026Sn7cwwZRw2pzQgADfZgD//9dIkIAAhckAgALsDiCAA5VFgIAAAmCA//+9rjA=
Date: Sun, 1 May 2011 18:56:58 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DF2C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427064550.GA597@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427121856.GA20633@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501153920.GA15210@infradead.org> <20110501154751.GA14040@kroah.com>
In-Reply-To: <20110501154751.GA14040@kroah.com>
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
> Sent: Sunday, May 01, 2011 11:48 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> 
> On Sun, May 01, 2011 at 11:39:21AM -0400, Christoph Hellwig wrote:
> > On Fri, Apr 29, 2011 at 04:32:35PM +0000, KY Srinivasan wrote:
> > > On the host-side, as part of configuring a guest  you can specify block devices
> > > as being under an IDE controller or under a
> > > SCSI controller. Those are the only options you have. Devices configured
> under
> > > the IDE controller cannot be seen in the guest under the emulated SCSI front-
> end which is
> > > the scsi driver (storvsc_drv). So, when you do a bus scan in the emulated scsi
> front-end,
> > > the devices enumerated will not include block devices configured under the
> IDE
> > > controller. So, it is not clear to me how I can do what you are proposing given
> the
> > > restrictions imposed by the host.
> >
> > Just because a device is not reported by REPORT_LUNS doesn't mean you
> > can't talk to it using a SCSI LLDD.  We have SCSI transports with all
> > kinds of strange ways to discover devices.  Using scsi_add_device you
> > can add LUNs found by your own discovery methods, and use all the
> > existing scsi command handling.
> 
> Yeah, it seems to me that no matter how the user specifies the disk
> "type" for the guest configuration, we should use the same Linux driver,
> with the same naming scheme for both ways.
> 
> As Christoph points out, it's just a matter of hooking the device up to
> the scsi subsystem.  We do that today for ide, usb, scsi, and loads of
> other types of devices all with the common goal of making it easier for
> userspace to handle the devices in a standard manner.

This is not what is being done in Xen and KVM - they both have a PV front-end
block drivers that is not managed by the scsi stack. The Hyper-V block driver is
equivalent to what we have in Xen and KVM in this respect.

Regards,

K. Y 

