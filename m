Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab2CVPQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:16:39 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:21126 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2CVPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:16:38 -0400
X-IronPort-AV: E=Sophos;i="4.73,630,1325462400"; 
   d="scan'208";a="11482806"
Date: Thu, 22 Mar 2012 15:16:43 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xenbus: Add quirk to deal with misconfigured
 backends.
In-Reply-To: <20120322132102.GA22545@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1203221511380.15151@kaball-desktop>
References: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1203221040030.15151@kaball-desktop> <1332413546.8817.64.camel@zakaz.uk.xensource.com> <20120322132102.GA22545@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Mar 22, 2012 at 10:52:26AM +0000, Ian Campbell wrote:
> > On Thu, 2012-03-22 at 10:44 +0000, Stefano Stabellini wrote:
> > > On Thu, 22 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > > > A rather annoying and common case is when booting a PVonHVM guest
> > > > and exposing the PV KBD and PV VFB - as both of those do not
> > > > make any sense. The HVM guest is using the VGA driver and the emulated
> > > > keyboard for this. So we provide a very basic quirk framework
> > > > (can be expanded in the future) to not wait for 6 minutes for those devices
> > > > to initialize - they never wont.
> > > > 
> > > > To trigger this, put this in your guest config:
> > > > 
> > > > vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> > > > 
> > > > instead of this:
> > > > vnc=1
> > > > vnclisten="0.0.0.0"
> > > 
> > > While I do understand the issue you are trying to solve, it actually
> > > makes sense to have PV KBD (and PV VFB maybe in the future) in a PVonHVM
> > > guest. In particular PV KVB is already enabled in upstream QEMU for
> > > PVonHVM guests because it allows users to have a keyboard and mouse
> 
> How about looking for a particular Xen version? The patch
> could check for anything less than 4.2 (does 4.2 use that version of
> QEMU that has this implemented?). I can't find any way to get the QEMU
> version from within the guest - DMI reports:
> 
> DMI: Xen HVM domU, BIOS 4.1-120322 03/22/2012

I am not a great fun of enabling/disabling features depending on the Xen
version. What happens for example if a Linux distro decided to patch
QEMU 4.1 to enable PV KBD for PVonHVM guests?
I realize that it is unlikely but it is possible.
Maybe we can reduce the timeout for non essential devices (everything
expect disk, network and console) like Ian suggested?
