Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1HXDIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:08:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51880 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738Ab1HXDIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:08:30 -0400
X-Sasl-enc: Sf/iSGYrMMilFOAb2HXf0sj7mShUecpDMdRmDBmOfbH/ 1314155309
Date: Tue, 23 Aug 2011 19:58:27 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 081/117] Staging: hv: vmbus: Introduce a lock to protect
 the ext field in hv_device
Message-ID: <20110824025827.GB30779@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-81-git-send-email-kys@microsoft.com>
 <20110823230816.GN9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B238B@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B238B@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:55:12AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, August 23, 2011 7:08 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 081/117] Staging: hv: vmbus: Introduce a lock to protect the
> > ext field in hv_device
> > 
> > On Fri, Jul 15, 2011 at 10:47:09AM -0700, K. Y. Srinivasan wrote:
> > > The current mechanism for handling references in broken.
> > > Introduce a lock to protect the ext field in hv_device.
> > 
> > Why would that lock ever be needed?  How can things change to this
> > pointer in different ways like you are thinking it could?  Doesn't the
> > reference counting in the device itself handle this properly?
> 
> This is to deal with a potential race condition between the driver being
> unloaded and incoming traffic from the VMBUS side. The ext pointer is 
> device specific (either pointing to a storage or a network device) and what
> we are protecting is the pointer being set to NULL from the unload side when
> we might have a racing access from the interrupt side (on the incoming vmbus
> traffic).

I still don't think this is needed at all, the drivers should not have
to worry about this.  Something is wrong with the design if it is, as no
other bus needs something like this, right?

greg k-h
