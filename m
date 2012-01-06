Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030451Ab2AFQC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:02:27 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:54209 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030430Ab2AFQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:02:25 -0500
Date: Fri, 6 Jan 2012 11:00:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [Xen-devel] [PATCH 4/5] xen/pciback: Expand the warning message
 to include domain id.
Message-ID: <20120106160011.GD6125@phenom.dumpdata.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
 <1325724403-29642-5-git-send-email-konrad.wilk@oracle.com>
 <4F06C101020000780006AC32@nat28.tlf.novell.com>
 <20120106150338.GB5855@phenom.dumpdata.com>
 <1325865086.25206.512.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325865086.25206.512.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020202.4F071AF0.018B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 03:51:25PM +0000, Ian Campbell wrote:
> On Fri, 2012-01-06 at 15:03 +0000, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jan 06, 2012 at 08:38:09AM +0000, Jan Beulich wrote:
> > > >>> On 05.01.12 at 01:46, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > > > When a PCI device is transferred to another domain and it is still
> > > > in usage (from the internal perspective), mention which other
> > > > domain is using it to aid in debugging.
> > > > 
> > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > ---
> > > >  drivers/xen/xen-pciback/xenbus.c |    6 ++++--
> > > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
> > > > index 474d52e..fa130bd 100644
> > > > --- a/drivers/xen/xen-pciback/xenbus.c
> > > > +++ b/drivers/xen/xen-pciback/xenbus.c
> > > > @@ -243,8 +243,10 @@ static int xen_pcibk_export_device(struct 
> > > > xen_pcibk_device *pdev,
> > > >  	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
> > > >  	if (xen_register_device_domain_owner(dev,
> > > >  					     pdev->xdev->otherend_id) != 0) {
> > > > -		dev_err(&dev->dev, "device has been assigned to another " \
> > > > -			"domain! Over-writting the ownership, but beware.\n");
> > > > +		int other_domain = xen_find_device_domain_owner(dev);
> > > > +		dev_err(&dev->dev, "device has been assigned to %d " \
> > > > +			"domain! Over-writting the ownership, but beware.\n",
> > > > +			other_domain);
> > > 
> > > As you're touching this anyway, how about fixing the other minor
> > > issues with it too? E.g.
> > > 
> > > 		dev_err(&dev->dev, "Device appears to be assigned to dom%d!"
> > > 			" Overwriting the ownership, but beware.\n",
> > > 			xen_find_device_domain_owner(dev));
> > > 
> > > (a native English speaker may want to comment the "but beware"
> > > part - it reads odd for me).
> > 
> > Hm, lets ask the English speakers. Ian?
> 
> I think you underestimate a native speakers ability to mangle a
> language. Especially this one ;-)
> 
> Anyway, I think it's unnecessary, so you may as well drop it and just
> have:
> 
>  		dev_err(&dev->dev, "Device appears to be assigned to dom%d!"
>  			" Overwriting the ownership.\n",
>  			xen_find_device_domain_owner(dev));
> 
> I suppose you might want "Overriding ownership to dom%d".

OK. To the point and potentially can fit in 80 lines :-).

Will spin out the patch next week-sih.
