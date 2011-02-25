Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1BYPiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:38:00 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:41107 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1BYPiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:38:00 -0500
X-IronPort-AV: E=Sophos;i="4.62,225,1297036800"; 
   d="scan'208";a="4510677"
Date: Fri, 25 Feb 2011 15:38:35 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/7] xen-blkfront: handle Xen major numbers other than
 XENVBD
In-Reply-To: <20110222191948.GA17866@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1102251528480.2156@kaball-desktop>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop> <1297878787-378-3-git-send-email-stefano.stabellini@eu.citrix.com> <20110222191948.GA17866@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Konrad Rzeszutek Wilk wrote:
> > @@ -120,6 +120,10 @@ static DEFINE_SPINLOCK(minor_lock);
> >  #define EXTENDED (1<<EXT_SHIFT)
> >  #define VDEV_IS_EXTENDED(dev) ((dev)&(EXTENDED))
> >  #define BLKIF_MINOR_EXT(dev) ((dev)&(~EXTENDED))
> > +#define EMULATED_HD_DISK_MINOR_OFFSET (0)
> > +#define EMULATED_HD_DISK_NAME_OFFSET (EMULATED_HD_DISK_MINOR_OFFSET / 256)
> 
> 0 / 256 ? Why not just 0?

Because if we set EMULATED_HD_DISK_MINOR_OFFSET to something different
from 0, then the divison by 256 would matter.
If you look at the code below you'll see that:

offset = minor / nr_parts;

where nr_parts is 256 and offset is the the device name offset.
EMULATED_HD_DISK_MINOR_OFFSET is the offset of the variable "minor" and
EMULATED_HD_DISK_NAME_OFFSET is the offset of the variable "offset".
