Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab1GAEpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 00:45:19 -0400
Received: from mail.vyatta.com ([76.74.103.46]:57255 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1GAEpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 00:45:18 -0400
Date: Thu, 30 Jun 2011 21:45:12 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/40] Staging: hv: Driver cleanup
Message-ID: <20110630214512.1b9125b7@nehalam.ftrdhcpuser.net>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480816C3AF@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
	<20110630193346.GA22707@infradead.org>
	<6E21E5352C11B742B20C142EB499E0480816C384@TK5EX14MBXC126.redmond.corp.microsoft.com>
	<20110630164808.17c506a4@nehalam.ftrdhcpuser.net>
	<6E21E5352C11B742B20C142EB499E0480816C3AF@TK5EX14MBXC126.redmond.corp.microsoft.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 00:19:38 +0000
KY Srinivasan <kys@microsoft.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Stephen Hemminger [mailto:shemminger@vyatta.com]
> > Sent: Thursday, June 30, 2011 7:48 PM
> > To: KY Srinivasan
> > Cc: Christoph Hellwig; devel@linuxdriverproject.org; gregkh@suse.de; linux-
> > kernel@vger.kernel.org; virtualization@lists.osdl.org
> > Subject: Re: [PATCH 00/40] Staging: hv: Driver cleanup
> > 
> > On Thu, 30 Jun 2011 23:32:34 +0000
> > KY Srinivasan <kys@microsoft.com> wrote:
> > 
> > >
> > > > -----Original Message-----
> > > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > > Sent: Thursday, June 30, 2011 3:34 PM
> > > > To: KY Srinivasan
> > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > > > Subject: Re: [PATCH 00/40] Staging: hv: Driver cleanup
> > > >
> > > > On Wed, Jun 29, 2011 at 07:38:21AM -0700, K. Y. Srinivasan wrote:
> > > > > Further cleanup of the hv drivers:
> > > > >
> > > > > 	1) Cleanup the reference counting mess for both stor and net devices.
> > > >
> > > > I really don't understand the need for reference counting on the storage
> > > > side, especially now that you only have a SCSI driver.  The SCSI
> > > > midlayer does proper counting on it's objects (Scsi_Host, scsi_device,
> > > > scsi_cmnd), so you'll get that for free given that SCSI drivers just
> > > > piggyback on the midlayer lifetime rules.
> > > >
> > > > For now your patches should probably go in as-is, but mid-term you
> > > > should be able to completely remove that code on the storage side.
> > > >
> > >
> > > Greg,
> > >
> > > I am thinking of  going back to my original implementation where I had one scsi
> > host
> > > per IDE device. This will certainly simply the code. Let me know what you think.
> > If you
> > > agree with this approach, please drop this patch-set, I will send you a new set
> > of patches.
> > 
> > I think there ref counting on network devices is also unneeded
> > as long as the unregister logic handles RCU correctly. The network layer
> > calls the driver unregister routine after all packets are gone.
> On the networking side, what about incoming packets that may be racing
> with the device destruction. The current ref counting scheme deals with
> that case.

Not sure how HV driver tells hypervisor to stop sending packets. But the
destructor is not called until after all other CPU's are done processing
packets from that device.
