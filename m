Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2CVNZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:25:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40654 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2CVNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:25:29 -0400
Date: Thu, 22 Mar 2012 09:21:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xenbus: Add quirk to deal with
 misconfigured backends.
Message-ID: <20120322132102.GA22545@phenom.dumpdata.com>
References: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1203221040030.15151@kaball-desktop>
 <1332413546.8817.64.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332413546.8817.64.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F6B2841.00E1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 10:52:26AM +0000, Ian Campbell wrote:
> On Thu, 2012-03-22 at 10:44 +0000, Stefano Stabellini wrote:
> > On Thu, 22 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > > A rather annoying and common case is when booting a PVonHVM guest
> > > and exposing the PV KBD and PV VFB - as both of those do not
> > > make any sense. The HVM guest is using the VGA driver and the emulated
> > > keyboard for this. So we provide a very basic quirk framework
> > > (can be expanded in the future) to not wait for 6 minutes for those devices
> > > to initialize - they never wont.
> > > 
> > > To trigger this, put this in your guest config:
> > > 
> > > vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> > > 
> > > instead of this:
> > > vnc=1
> > > vnclisten="0.0.0.0"
> > 
> > While I do understand the issue you are trying to solve, it actually
> > makes sense to have PV KBD (and PV VFB maybe in the future) in a PVonHVM
> > guest. In particular PV KVB is already enabled in upstream QEMU for
> > PVonHVM guests because it allows users to have a keyboard and mouse

How about looking for a particular Xen version? The patch
could check for anything less than 4.2 (does 4.2 use that version of
QEMU that has this implemented?). I can't find any way to get the QEMU
version from within the guest - DMI reports:

DMI: Xen HVM domU, BIOS 4.1-120322 03/22/2012

> > without USB emulation, that requires lots of wakes up in QEMU.
> > 
> > Maybe we could just reduce the timeout in general for all the PV
> > devices? After all, why are we waiting 6 minutes? I could understand 6
> > seconds, but 6 minutes seem really too much.
> 
> This was increased based on empirical evidence, way back (circa
> 150:09c88868e344 in linux-2.6.18-xen.hg)
> 
> It really can happen when starting lots of guests on a heavily loaded
> dom0 that you timeout when connecting devices, at which point the guest
> fails to boot if it happened to contain the root filesystem.
> 
> Maybe a halfway house would be to wait a the longer time for more
> critical devices (like disks and nics)?
> 
> Ian.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
