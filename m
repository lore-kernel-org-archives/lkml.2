Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab1FWPPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:15:33 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:39116 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839Ab1FWPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:15:32 -0400
X-IronPort-AV: E=Sophos;i="4.65,413,1304294400"; 
   d="scan'208";a="6450958"
Date: Thu, 23 Jun 2011 16:19:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: =?UTF-8?Q?Penttil=C3=A4_Mika?= <mika.penttila@ixonos.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86_64: do not assume head_64.S used 4KB pages when
 !use_pse
In-Reply-To: <1A61D8EA6755AF458F06EA669A4EC8182F05B0C6@JKLMAIL02.ixonos.local>
Message-ID: <alpine.DEB.2.00.1106231604070.12963@kaball-desktop>
References: <1A61D8EA6755AF458F06EA669A4EC8182F05B07E@JKLMAIL02.ixonos.local> <alpine.DEB.2.00.1106231354350.12963@kaball-desktop> <1A61D8EA6755AF458F06EA669A4EC8182F05B0C6@JKLMAIL02.ixonos.local>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-559770896-1308841709=:12963"
Content-ID: <alpine.DEB.2.00.1106231610240.12963@kaball-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-559770896-1308841709=:12963
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1106231610241.12963@kaball-desktop>

On Thu, 23 Jun 2011, Penttilä Mika wrote:
> > > And arch/x86/mm/init.c also has:
> > >
> > > #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
> > >         /*
> > >          * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use
> > small pages.
> > >          * This will simplify cpa(), which otherwise needs to support
> > splitting
> > >          * large pages into small in interrupt context, etc.
> > >          */
> > >         use_pse = use_gbpages = 0;
> > > #else
> > >         use_pse = cpu_has_pse;
> > >         use_gbpages = direct_gbpages;
> > > #endif
> > >
> > >
> > > So big pages are also not used for DEBUG_PAGEALLOC and KMEMCHECK
> > configs even if head_32.S did.
> > 
> > Right, but that is not a problem because head_32.S always uses 4KB
> > pages.
> 
> We use large pages FOR PAE kernels on x86-32 there
> 
 
Do you mean we use large pages for PAE kernels on x86_32 in
arch/x86/mm/init.c:init_memory_mapping?
That wouldn't be a problem for this patch.

The problem I am trying to solve occurs when head_64.S doesn't allocate
any pte pages because it is using 2MB pages, while init_memory_mapping
wants to use 4KB pages (for example because the user set
CONFIG_DEBUG_PAGEALLOC).

So on x86_32 is not going to be an issue because head_32.S doesn't use
2MB or 4MB pages as far as I can tell, even if the hardware supports
them.
Please correct me if I am wrong but I don't see any _PAGE_PSE in
head_32.S.
--8323329-559770896-1308841709=:12963--
