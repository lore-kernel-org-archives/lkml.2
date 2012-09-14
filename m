Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab2INRei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:34:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46863 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759068Ab2INRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:34:34 -0400
Date: Fri, 14 Sep 2012 18:33:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 07/31] arm64: Process management
Message-ID: <20120914173352.GC2927@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-8-git-send-email-catalin.marinas@arm.com>
 <20120814235013.GC19607@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814235013.GC19607@quad.lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 12:50:13AM +0100, Olof Johansson wrote:
> On Tue, Aug 14, 2012 at 06:52:08PM +0100, Catalin Marinas wrote:
> 
> > diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> > new file mode 100644
> > index 0000000..c4a4e1c
> > --- /dev/null
> > +++ b/arch/arm64/kernel/process.c
> > @@ -0,0 +1,416 @@
> 
> [...]
> > +/*
> > + * Function pointers to optional machine specific functions
> > + */
> > +void (*pm_power_off)(void);
> > +EXPORT_SYMBOL(pm_power_off);
> > +
> > +void (*pm_restart)(const char *cmd);
> > +EXPORT_SYMBOL_GPL(pm_restart);
> [...]
> > +void (*pm_idle)(void) = default_idle;
> > +EXPORT_SYMBOL(pm_idle);
> 
> Does it really make sense to export these to modules?

Changed them to _GPL now but we may still want them exported to modules.
Who knows, we may just have the SoC code in a loadable module (from
initramfs).

> I find the powerpc way of having a machine descriptor structure with these
> (and other) function pointers in it a bit cleaner, since it gives you
> one place to plug it all in. I'd recommend that you consider doing that
> here as well, for these three and potentially other cases in the future.
> 
> (See arch/powerpc/include/asm/machdep.h, struct machdep_calls).

At some point we may add them but currently I want the SoC code to be
minimal.

-- 
Catalin
