Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2CHPw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:52:27 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53533 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757859Ab2CHPwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:52:22 -0500
X-Sasl-enc: hahfll+6RezRZI9KQCYZCrs70l4InaC7tV30HEkvCVoE 1331221941
Date: Thu, 8 Mar 2012 07:52:19 -0800
From: Greg KH <greg@kroah.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Message-ID: <20120308155219.GC5907@kroah.com>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
 <20120307201746.GA20900@aepfle.de>
 <20120307204946.GA4413@kroah.com>
 <20120308061615.GA25237@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308061615.GA25237@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 07:16:16AM +0100, Olaf Hering wrote:
> On Wed, Mar 07, Greg KH wrote:
> 
> > On Wed, Mar 07, 2012 at 09:17:46PM +0100, Olaf Hering wrote:
> > > On Wed, Mar 07, Haiyang Zhang wrote:
> > > 
> > > 
> > > > @@ -482,7 +484,7 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
> > > >  
> > > >  /* The one and only one */
> > > >  static struct  hv_driver netvsc_drv = {
> > > > -	.name = "netvsc",
> > > > +	.name = MODULE_NAME,
> > > 
> > > It would be nice if this could be applied to 3.3.
> > > hv_storvsc and hid-hyperv already use the same naming, this patch was
> > > send last year already but was not applied for some reason.
> > 
> > What userspace tools depend on this that requires it to be in 3.3?
> 
> It represents the module names, at least for pci and other bus types.

Yes, but no one should care what the name of the module is.

> hwinfo uses it to recognize a network interface (storage in case of
> hv_storvsc).

That tool should report the real module name, not rely on the name to
match based on the structure, if you really care about the real module
name.

greg k-h
