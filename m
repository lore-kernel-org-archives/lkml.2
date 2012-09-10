Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2IJQoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:44:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46938 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676Ab2IJQoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:44:08 -0400
Date: Mon, 10 Sep 2012 17:43:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/31] arm64: CPU support
Message-ID: <20120910164328.GA8238@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-9-git-send-email-catalin.marinas@arm.com>
 <201209071924.38430.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209071924.38430.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 08:24:38PM +0100, Arnd Bergmann wrote:
> On Friday 07 September 2012, Catalin Marinas wrote:
> > +#include <asm/cputable.h>
> > +
> > +extern unsigned long __cpu_setup(void);
> > +
> > +struct cpu_info __initdata cpu_table[] = {
> > +	{
> > +		.cpu_id_val	= 0x000f0000,
> > +		.cpu_id_mask	= 0x000f0000,
> > +		.cpu_name	= "AArch64 Processor",
> > +		.cpu_setup	= __cpu_setup,
> > +	},
> > +	{ /* Empty */ },
> > +};
> 
> > +#define MAIR(attr, mt)	((attr) << ((mt) * 8))
> > +
> > +ENTRY(cpu_proc_init)
> > +	ret
> > +ENDPROC(cpu_proc_init)
> > +
> > +ENTRY(cpu_proc_fin)
> > +	ret
> > +ENDPROC(cpu_proc_fin)
> 
> 
> These seem to be leftovers from multi-cpu support that can be removed.

Actually cpu_proc_fin() needs to be implemented for turning the caches
off during setup_restart(). But I'll rename it to something more
meaningful like cpu_cache_off(). The other can go.

-- 
Catalin
