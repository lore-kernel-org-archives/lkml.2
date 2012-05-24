Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab2EXS4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:56:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30321 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2EXS4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:56:31 -0400
Date: Thu, 24 May 2012 14:49:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Message-ID: <20120524184947.GA28338@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>> -static struct miscdevice mce_chrdev_device = {
> >>>> +struct miscdevice mce_chrdev_device = {
> >>>>  	MISC_MCELOG_MINOR,
> >>>>  	"mcelog",
> >>>>  	&mce_chrdev_ops,
> >>> 
> >>> You're still reusing those - pls, define your own 'struct miscdevice
> >>> mce_chrdev_device' in drivers/xen/ or somewhere convenient and
> >>> your own mce_chrdev_ops. The only thing you should be touching in
> >>> arch/x86/.../mcheck/ is the export of MISC_MCELOG_MINOR.
> >>> 
> >>> Thanks.
> >> 
> >> I'm *not* reuse native code.
> >> I have defined 'struct miscdevice xen_mce_chrdev_device' in
> >> drivers/xen, and I also implement xen_mce_chrdev_ops, they are all
> >> xen-self-contained.  
> >> 
> >> The patch just redirect native mce_chrdev_device to
> >> xen_mce_chrdev_device when running under xen environment. 
> >> It didn't change any native code (except just cancel
> >> mce_chrdev_device 'static'), and will not break native logic. 
> > 
> > Why are you doing that?
> > 
> > Why don't you do
> > 
> > 	misc_register(&xen_mce_chrdev_device);
> > 
> > in xen_early_init_mcelog() ?
> > 
> > This way there'll be no arch/x86/ dependencies at all.
> 
> The reason is, if we do so, it would be covered by native misc_register(&mce_chrdev_device) later when native kernel init (xen init first and then start native kernel).

Won't the second registration (so the original one) of the major fail? So the mce_log
would just error out since somebody already registered?
