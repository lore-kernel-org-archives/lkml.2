Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2HBBtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 21:49:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:6153 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab2HBBtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 21:49:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192269381"
Date: Wed, 1 Aug 2012 18:49:11 -0700
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC v2 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20120802014911.GC17548@jonmason-lab>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
 <1343607994-32415-2-git-send-email-jon.mason@intel.com>
 <20120731222555.GB19134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731222555.GB19134@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:25:55PM -0700, Greg KH wrote:
> On Sun, Jul 29, 2012 at 05:26:33PM -0700, Jon Mason wrote:
> > +struct ntb_transport_qp;
> > +
> > +struct ntb_client {
> > +	char *name;
> > +	int (*probe) (struct pci_dev *pdev);
> > +	void (*remove) (struct pci_dev *pdev);
> > +};
> 
> Why isn't this tied into the driver model?  That looks like you really
> want to use a 'struct device' here, right?
> 
> Then you have drivers that bind to them, and your devices show up in
> sysfs, which is probably a requirement you have, right?

I was trying to do something more light-weight than that and avoid the
complexity, but this is probably the direction it needs to go.

Thanks,
Jon

> 
> greg k-h
