Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1JCQ1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:27:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25911 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1JCQ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:27:07 -0400
Date: Mon, 3 Oct 2011 12:26:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [Xen-devel] [PATCH 7/9] xen/xenbus: Check before dereferencing
 it.
Message-ID: <20111003162644.GF17108@phenom.oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-8-git-send-email-konrad.wilk@oracle.com>
 <1317369681.26672.218.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317369681.26672.218.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4E89E256.009B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 09:01:21AM +0100, Ian Campbell wrote:
> On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> > . we do the check whether 'xdev' is NULL - but after we have
> > dereferenced it.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/xenbus/xenbus_probe_backend.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
> > index 60adf91..331589a 100644
> > --- a/drivers/xen/xenbus/xenbus_probe_backend.c
> > +++ b/drivers/xen/xenbus/xenbus_probe_backend.c
> > @@ -103,10 +103,11 @@ static int xenbus_uevent_backend(struct device *dev,
> >  		return -ENODEV;
> >  
> >  	xdev = to_xenbus_device(dev);
> 
> to_xenbus_device is just container_of. The only way it would return NULL
> is if dev == offsetof(struct xenbus_device, dev), which isn't terribly
> likely. A more likely error would be dev == NULL and we just checked
> above.
> 
> > -	bus = container_of(xdev->dev.bus, struct xen_bus_type, bus);
> >  	if (xdev == NULL)
> >  		return -ENODEV;

Hm, in which case this 'xdev == NULL' is pointless. Will remove it.
