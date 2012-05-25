Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab2EYSJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 14:09:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22634 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2EYSJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 14:09:45 -0400
Date: Fri, 25 May 2012 14:03:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Message-ID: <20120525180303.GB27280@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524162605.GK27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED978@SHSMSX101.ccr.corp.intel.com>
 <20120524191039.GB28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C89@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351F0C89@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 06:01:04PM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> >>>> The reason is, if we do so, it would be covered by native
> >>>> misc_register(&mce_chrdev_device) later when native kernel init
> >>>> (xen init first and then start native kernel).
> >>>> Under such case, if linux running under xen platform, /dev/mcelog
> >>>> point to vcpu, that's pointless since it cannot get any mcelog from
> >>>> physical cpu (which owned by xen).
> >>>> 
> >>>> Yes, we can use another misc device like /dev/xen-mcelog, w/
> >>>> another device minor like 226, but that's not good for userspace
> >>>> mcelog tools. As far as I know, Novell mcelog use unified
> >>>> /dev/mcelog interface for linux running under either bare metal or
> >>>> xen platform. 
> >>> 
> >>> Maybe create a symlink in /dev/mcelog pointing to /dev/xen-mcelog?
> >>> 
> >>> That should solve it.
> >> 
> >> Kernel has created a file /dev/mcelog no matter running at native or
> >> xen platform. 
> >> If xen try to mask kernel creating /dev/mcelog, that would be
> >> harmful to native kernel. 
> > 
> > Huh? The Xen code won't run under native kernel so how will it mask
> > it? 
> 
> Hmm, I mean 'xen related code' of linux kernel, e.g. drivers/xen/...

OK? I am still not getting what you are saying. Could you please
rephrase it?

Why would disabling the generic "/dev/mcelog" and use your version
of "/dev/mcelog" be harmful? I think this is what Boris was hinting
as the proper way of doing it.

