Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2EaPh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:37:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18688 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2EaPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:37:26 -0400
Date: Thu, 31 May 2012 11:30:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
Message-ID: <20120531153018.GD9876@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
 <20120531135009.GC14515@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531135009.GC14515@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 03:50:09PM +0200, Borislav Petkov wrote:
> On Thu, May 31, 2012 at 12:57:44PM +0000, Liu, Jinsong wrote:
> > From 1a7951d6ca01d7f2c9dd2bdb6de5f8e7fdcb8bbd Mon Sep 17 00:00:00 2001
> > From: root <root@ljsromley.bj.intel.com>
> > Date: Fri, 1 Jun 2012 03:12:51 +0800
> > Subject: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
> > 
> > When MCA error occurs, it would be handled by Xen hypervisor first,
> > and then the error information would be sent to initial domain for logging.
> > 
> > This patch gets error information from Xen hypervisor and convert
> > Xen format error into Linux format mcelog. This logic is basically
> > self-contained, not touching other kernel components.
> > 
> > By using tools like mcelog tool users could read specific error information,
> > like what they did under native Linux.
> > 
> > To test follow directions outlined in Documentation/acpi/apei/einj.txt
> > 
> > Signed-off-by: Ke, Liping <liping.ke@intel.com>
> > Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> > ---
> >  arch/x86/include/asm/xen/hypercall.h |    8 +
> >  arch/x86/kernel/cpu/mcheck/mce.c     |    4 +-
> >  arch/x86/xen/enlighten.c             |    5 +-
> >  drivers/xen/Kconfig                  |    8 +
> >  drivers/xen/Makefile                 |    1 +
> >  drivers/xen/mcelog.c                 |  392 ++++++++++++++++++++++++++++++++++
> >  include/linux/miscdevice.h           |    1 +
> >  include/xen/interface/xen-mca.h      |  385 +++++++++++++++++++++++++++++++++
> >  8 files changed, 798 insertions(+), 6 deletions(-)
> >  create mode 100644 drivers/xen/mcelog.c
> >  create mode 100644 include/xen/interface/xen-mca.h
> 
> For the mce bits:
> 
> Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>

Sweet. Let me test it on a variety of hardware with Xen and without Xen
with 32/64 variations to double-check.
