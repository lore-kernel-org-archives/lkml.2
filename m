Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2AIPYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:24:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:62251 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2AIPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:24:49 -0500
Date: Mon, 9 Jan 2012 10:22:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 4/5] xen/pciback: Expand the warning message
 to include domain id.
Message-ID: <20120109152254.GA26880@phenom.dumpdata.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
 <1325724403-29642-5-git-send-email-konrad.wilk@oracle.com>
 <4F06C101020000780006AC32@nat28.tlf.novell.com>
 <20120106150338.GB5855@phenom.dumpdata.com>
 <1325865086.25206.512.camel@zakaz.uk.xensource.com>
 <20120106160011.GD6125@phenom.dumpdata.com>
 <20120106221927.GA10248@phenom.dumpdata.com>
 <1326102657.17210.11.camel@zakaz.uk.xensource.com>
 <20120109151124.GE25563@phenom.dumpdata.com>
 <1326122172.17210.109.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326122172.17210.109.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F0B06BB.00C1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > -		dev_err(&dev->dev, "device has been assigned to another " \
> > > > -			"domain! Over-writting the ownership, but beware.\n");
> > > > +		dev_err(&dev->dev, "Overriding ownership to dom%d.\n",
> > > > +			xen_find_device_domain_owner(dev));
> > > 
> > > That sounds like you are going to be assigning the ownership to that
> > > dom, but xen_find_device_domain_owner so aren't you actually steeling
> > > ownership from that domain?
> > 
> > Duh! I will do s/to/from/
> 
> Maybe s/Overriding/Stealing/ too? "Overriding ownership from xxx" sounds
> a bit odd to me.

Bingo! "Stealing ownership from dom%d." it is!
