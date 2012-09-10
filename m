Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2IJOyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:54:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43000 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060Ab2IJOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:54:11 -0400
Date: Mon, 10 Sep 2012 15:53:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120910145329.GE27042@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <201209101353.34325.arnd@arndb.de>
 <alpine.LFD.2.02.1209101007160.28681@xanadu.home>
 <201209101448.20745.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209101448.20745.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:48:20PM +0100, Arnd Bergmann wrote:
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

On arm64 I don't have run-time code patching (yet) but a PHYS_OFFSET
variable set at boot time. It may prove useful to have run-time code
patching but that's just an optimisation that can be added later.

-- 
Catalin
