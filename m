Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2HTQB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:01:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37508 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab2HTQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:01:26 -0400
Date: Mon, 20 Aug 2012 17:00:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 08/31] arm64: CPU support
Message-ID: <20120820160053.GB912@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-9-git-send-email-catalin.marinas@arm.com>
 <201208151356.05416.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151356.05416.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 02:56:05PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/procinfo.h
...
> > +struct proc_info_list {
> > +	unsigned int		cpu_val;
> > +	unsigned int		cpu_mask;
> > +	unsigned long		__cpu_flush;		/* used by head.S */
> > +	const char		*cpu_name;
> > +};
> > +
> > +#else	/* __KERNEL__ */
> > +#include <asm/elf.h>
> > +#warning "Please include asm/elf.h instead"
> > +#endif	/* __KERNEL__ */
> > +#endif
> 
> I think you forgot to remove this file when you removed MULTI_CPU.

proc_info_list() structure is still used just for the CPU name and setup
function (e.g. we need to apply errata workaround on a certain CPU). But
as Olof suggested, I better move all this to a cputable.c file.

-- 
Catalin
