Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1JCQPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:15:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50079 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1JCQPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:15:13 -0400
Date: Mon, 3 Oct 2011 12:14:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 1/9] xen/pciback: Do not dereference psdev
 during printk when it is NULL.
Message-ID: <20111003161450.GC17108@phenom.oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-2-git-send-email-konrad.wilk@oracle.com>
 <4E858C850200007800058A6E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E858C850200007800058A6E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E89DF8D.00F4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:31:49AM +0100, Jan Beulich wrote:
> >>> On 29.09.11 at 21:52, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > . instead use printk(.. facility.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/xen-pciback/pci_stub.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/xen/xen-pciback/pci_stub.c 
> > b/drivers/xen/xen-pciback/pci_stub.c
> > index aec214a..32d6891 100644
> > --- a/drivers/xen/xen-pciback/pci_stub.c
> > +++ b/drivers/xen/xen-pciback/pci_stub.c
> > @@ -514,9 +514,11 @@ static void kill_domain_by_device(struct pcistub_device 
> > *psdev)
> >  	int err;
> >  	char nodename[PCI_NODENAME_MAX];
> >  
> > -	if (!psdev)
> > -		dev_err(&psdev->dev->dev,
> > -			"device is NULL when do AER recovery/kill_domain\n");
> > +	if (!psdev) {
> > +		printk(KERN_ERR DRV_NAME
> > +			":device is NULL when do AER recovery/kill_domain\n");
> > +		return;
> > +	}
> 
> This is bogus - all callers of this function already make sure psdev is
> non-NULL, so imo the check should be removed or replaced with a
> BUG_ON().

Done!
