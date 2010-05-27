Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0E0M0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:26:01 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:3073 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0E0M0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:26:00 -0400
X-IronPort-AV: E=Sophos;i="4.53,311,1272844800"; 
   d="scan'208";a="119181"
Date: Thu, 27 May 2010 13:29:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH 11/11] Unplug emulated disks and nics
In-Reply-To: <4BFD8BB0.90301@goop.org>
Message-ID: <alpine.DEB.2.00.1005271322010.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-11-git-send-email-stefano.stabellini@eu.citrix.com> <4BFC3390.4060503@goop.org> <alpine.DEB.2.00.1005261325110.25605@kaball-desktop> <4BFD8BB0.90301@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Jeremy Fitzhardinge wrote:
> On 05/26/2010 05:27 AM, Stefano Stabellini wrote:
> > It is needed for LINUX_VERSION_CODE, see below:
> >
> >   
> >>> +
> >>> +#define XEN_IOPORT_MAGIC_VAL 0x49d2
> >>> +#define XEN_IOPORT_LINUX_PRODNUM 0xffff
> >>> +#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
> >>>       
> 
> Ah.  What's that for?  Does qemu change its behaviour depending on the
> kernel version?  Ah, something to do with blacklisting.  But is the
> Linux kernel version the most useful value here?  Shouldn't there be
> some kind of separate version number?  And what's the blacklisting stuff
> for anyway?
> 

Well at the moment qemu doesn't actually change behaviour but as part of
the protocol negotiation the pv drivers are supposed to communicate
their version number to qemu. Also it is possible to blacklist a
particular pv driver version in qemu even though I don't think it is
actually used at the moment.
Regarding what version number should we give to qemu, I guess we could
have our own separate version number here, independent fron the linux
version. I'll start from 1 then.


> Wow, this interface is perverse.  It reuses the same IO port but changes
> function depending on the size of the IO?  Again, wow.
 
Yeah, before you ask, I didn't write it :)
