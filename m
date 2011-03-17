Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1CQMgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:36:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:10292 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab1CQMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:36:03 -0400
X-IronPort-AV: E=Sophos;i="4.63,199,1299456000"; 
   d="scan'208";a="4839715"
Date: Thu, 17 Mar 2011 12:35:31 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Yinghai Lu <yinghai@kernel.org>, Mike Waychison <mikew@google.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Priyanka Gupta <priyankag@google.com>
Subject: Re: [PATCH] watchdog, SP5100: Check if firmware has set correct
 value in tcobase.
In-Reply-To: <20110317022331.GA3528@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1103171155240.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop> <20110311222129.GA3168@dumpdata.com> <alpine.DEB.2.00.1103161150010.3382@kaball-desktop> <alpine.DEB.2.00.1103161442210.3382@kaball-desktop> <4D80F992.10603@kernel.org>
 <alpine.DEB.2.00.1103161757040.3382@kaball-desktop> <4D812180.5030102@kernel.org> <AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com> <4D812919.30706@kernel.org> <20110317022331.GA3528@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 16, 2011 at 02:18:17PM -0700, Yinghai Lu wrote:
> > 
> > 
> > Stefano found SP5100 TCO watchdog driver using wrong address.
> > 
> > [    9.148536] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
> > [    9.148628] DEBUG __ioremap_caller WARNING address=b8fe00 size=8 valid=1 reserved=1
> > 
> > and e820 said that range is RAM.
> > 
> > We should check if we can use that reading out. BIOS could just program wrong address there.
> > 
> > -v2: Mike pointed out one path need one release.
> > 
> > Reported-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by:Yinghai Lu <yinghai@kernel.org>
> > Acked-by: Mike Waychison <mikew@google.com>
> 
> I have no idea why it worked the first time b/c this:
> 
> 
> > +	if (request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE, "SP5100 TCO")) {
> 
> is wrong. It should have been "if (!request...")..
> 
> With that, and with Stefano's patches (stefano/2.6.38-rc6-mm-fix) on top of 2.6.39-rc0 it boots up fine.

Yinghai, thanks for the patch!
I hope that we are not going to find any more of this kind of issues
with other drivers and other BIOSes.
