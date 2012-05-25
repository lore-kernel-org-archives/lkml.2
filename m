Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2EYVWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:22:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26057 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2EYVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:22:06 -0400
Date: Fri, 25 May 2012 17:15:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Message-ID: <20120525211524.GC21344@phenom.dumpdata.com>
References: <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524162605.GK27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED978@SHSMSX101.ccr.corp.intel.com>
 <20120524191039.GB28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C89@SHSMSX101.ccr.corp.intel.com>
 <20120525180303.GB27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0E70@SHSMSX101.ccr.corp.intel.com>
 <20120525202309.GA14524@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F10DE@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351F10DE@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 08:47:20PM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> >> What I mean is,
> >> If mcelog.c create /dev/xen-mcelog (say, minor=226), native mce.c
> >> would create /dev/mcelog (minor=227). 
> >> Under such case, may we create a symlink in /dev/mcelog pointing to
> >> /dev/xen-mcelog, without touching native mce code? and how? 
> > 
> > I thought the idea was that we would create /dev/mcelog using the
> > same major/minor. 
> 
> Our current patch just use same major/minor, by redirection method. Is it acceptable?

https://lkml.org/lkml/2012/5/24/183 Borislav says:
"
Maybe create a symlink in /dev/mcelog pointing to /dev/xen-mcelog?

That should solve it.
" so that sounds like the right direction.

> 
> > 
> > However if you want to create /dev/xen-mcelog and then create from
> > the kernel another file in /dev that is name 'mcelog' and is a
> > symlink to /dev/mcelog - that is OK too. Obviously you will also need
> > to disable the generic '/dev/mcelog' (and that can be done in the
> > same way as lguest does it). 
> 
> No, that's not my purpose.
> 
> Thanks,
> Jinsong
