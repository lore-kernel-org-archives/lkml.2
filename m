Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2IJPAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:00:14 -0400
Received: from relais.videotron.ca ([24.201.245.36]:51102 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2IJPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:00:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 10 Sep 2012 11:00:07 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
In-reply-to: <201209101448.20745.arnd@arndb.de>
Message-id: <alpine.LFD.2.02.1209101053320.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <201209101353.34325.arnd@arndb.de>
 <alpine.LFD.2.02.1209101007160.28681@xanadu.home>
 <201209101448.20745.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Arnd Bergmann wrote:

> On Monday 10 September 2012, Nicolas Pitre wrote:
> > On Mon, 10 Sep 2012, Arnd Bergmann wrote:
> > > On Monday 10 September 2012, Catalin Marinas wrote:
> > > > On Mon, Sep 10, 2012 at 06:53:39AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > I think a bunch of other architectures can have relocatable kernels, which
> > > is useful e.g. for kdump. It does imply a small runtime cost and may have
> > > other disadvantages though.
> > 
> > Relocatable in physical space is what kdump actually needs, and that's 
> > what we already have here (as well as on ARM32 for that matter with 
> > CONFIG_ARM_PATCH_PHYS_VIRT).  Relocatable in the virtual space is costly 
> > and we shouldn't need to go there.
> 
> Ah, I see. I thought that the other architectures (powerpc and x86)
> doing this were actually building with -fPIC, but they do the same
> kind of early patching that we do.

This being said, on ARM we don't take advantage of this physically 
relocatable attribute with kdump.  Granted, PATCH_PHYS_VIRT was 
introduced after kdump support, therefore the kernel had to be copied at 
its expected physical location after the memory content there had been 
preserved.  These days the only thing that kdump would need to do is to 
just boot the kdump kernel in place with its reserved memory range and 
let it ioremap the previous kernel's memory for analysis.


Nicolas
