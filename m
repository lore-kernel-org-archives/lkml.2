Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab1LNTXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:23:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:51500 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab1LNTXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:23:38 -0500
Date: Wed, 14 Dec 2011 14:22:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bastian Blank <bastian@waldi.eu.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 6/6] xen/xenbus-backend: Only register device
 if communication ring is local
Message-ID: <20111214192237.GA1156@phenom.dumpdata.com>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
 <1323541791-18006-7-git-send-email-waldi@debian.org>
 <20111212154227.GB21558@phenom.dumpdata.com>
 <20111212182807.GB14966@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212182807.GB14966@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EE8F7B7.00B5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 07:28:07PM +0100, Bastian Blank wrote:
> On Mon, Dec 12, 2011 at 10:42:27AM -0500, Konrad Rzeszutek Wilk wrote:
> > On Sat, Dec 10, 2011 at 07:29:51PM +0100, Bastian Blank wrote:
> > > -module_init(xenbus_backend_init);
> > > -module_exit(xenbus_backend_exit);
> > 
> > Why are we removing the module functionality?
> > Can't this [the purpose of this patch] be done while still maintaining the module functionality?
> 
> Not really. The purpose is to register the device only if the ring is
> local. This information is not available to modules.
> 
> However we could just move the whole xenbus ring setup into a "module".
> Or is there any reason for this to be in a postcore_initcall, even if it
> is only operational after a userspace process works?

My thinking is that we do not want to use memory space if the kernel
is booted as baremetal (as there is no point of having Xen pieces around).
Modules work great for that.

But then part of this code is __init so some does get evicted, but not sure
how much. Could you measure this on baremetal please?

> 
> > >  int xenstored_ready;
> > >  
> > > +/* A flag to determine if xenstored is 'local' */
> > > +#ifdef CONFIG_XEN_BACKEND
> > > +static int xenstored_local;
> > 
> > bool?
> 
> Well. The other flags are int also.

Sure.. and they ought to be modified to bool too now that I think of it.

> 
> > > +			BUG();
> > No way. A WARN, sure - but BUG() is way too intense for this.
> 
> Okay.
> 
> Bastian
> 
> -- 
> The sight of death frightens them [Earthers].
> 		-- Kras the Klingon, "Friday's Child", stardate 3497.2
