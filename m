Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1IFXuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:50:25 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54793 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755407Ab1IFXuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:50:20 -0400
X-Sasl-enc: h4JebH9fZcA5LeKpXMazVD5+n8Db8u/5RhFqZk1VWWa4 1315353019
Date: Tue, 6 Sep 2011 16:48:11 -0700
From: Greg KH <greg@kroah.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Oren Weil <oren.jer.weil@intel.com>, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        alan@linux.intel.com
Subject: Re: [PATCH 05/12] staging: mei: adding watchdog ping
Message-ID: <20110906234811.GA15235@kroah.com>
References: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
 <1314798168-15613-6-git-send-email-oren.jer.weil@intel.com>
 <20110831165224.GF3705@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831165224.GF3705@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 07:52:24PM +0300, Dan Carpenter wrote:
> On Wed, Aug 31, 2011 at 04:42:41PM +0300, Oren Weil wrote:
> > +static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
> > +{
> > +	int ret = 0;
> > +	struct mei_device *dev;
> > +	dev = pci_get_drvdata(mei_device);
> > +
> > +	if (!dev)
> > +		return -ENODEV;
> > +
> > +	mutex_lock(&dev->device_lock);
> > +
> > +	if (dev->wd_cl.state != MEI_FILE_CONNECTED) {
> > +		dev_dbg(&dev->pdev->dev, "wd is not connected.\n");
> > +		ret = -ENODEV;
> > +		goto end;
> > +	}
> > +
> > +	/* Check if we can send the ping to HW*/
> > +	if (dev->mei_host_buffer_is_empty &&
> > +		mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
> > +			dev->mei_host_buffer_is_empty = false;
>         ^^^^^^^^^^^^^^^^
> 
> This is a two tab indent.  Don't do that.

Yeah, that's odd.

Oren, care to redo this patch and resend the whole series?

thanks,

greg k-h
