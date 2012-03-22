Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2CVKwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:52:30 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:58290 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab2CVKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:52:28 -0400
X-IronPort-AV: E=Sophos;i="4.73,629,1325462400"; 
   d="scan'208";a="11470099"
Message-ID: <1332413546.8817.64.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] xen/xenbus: Add quirk to deal with misconfigured
 backends.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Thu, 22 Mar 2012 10:52:26 +0000
In-Reply-To: <alpine.DEB.2.00.1203221040030.15151@kaball-desktop>
References: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com>
	 <alpine.DEB.2.00.1203221040030.15151@kaball-desktop>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 10:44 +0000, Stefano Stabellini wrote:
> On Thu, 22 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > A rather annoying and common case is when booting a PVonHVM guest
> > and exposing the PV KBD and PV VFB - as both of those do not
> > make any sense. The HVM guest is using the VGA driver and the emulated
> > keyboard for this. So we provide a very basic quirk framework
> > (can be expanded in the future) to not wait for 6 minutes for those devices
> > to initialize - they never wont.
> > 
> > To trigger this, put this in your guest config:
> > 
> > vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> > 
> > instead of this:
> > vnc=1
> > vnclisten="0.0.0.0"
> 
> While I do understand the issue you are trying to solve, it actually
> makes sense to have PV KBD (and PV VFB maybe in the future) in a PVonHVM
> guest. In particular PV KVB is already enabled in upstream QEMU for
> PVonHVM guests because it allows users to have a keyboard and mouse
> without USB emulation, that requires lots of wakes up in QEMU.
> 
> Maybe we could just reduce the timeout in general for all the PV
> devices? After all, why are we waiting 6 minutes? I could understand 6
> seconds, but 6 minutes seem really too much.

This was increased based on empirical evidence, way back (circa
150:09c88868e344 in linux-2.6.18-xen.hg)

It really can happen when starting lots of guests on a heavily loaded
dom0 that you timeout when connecting devices, at which point the guest
fails to boot if it happened to contain the root filesystem.

Maybe a halfway house would be to wait a the longer time for more
critical devices (like disks and nics)?

Ian.

