Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab2HXKoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:44:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61129 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757698Ab2HXKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:44:14 -0400
Date: Fri, 24 Aug 2012 11:43:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 21/31] arm64: 32-bit (compat) applications support
Message-ID: <20120824104338.GI7585@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-22-git-send-email-catalin.marinas@arm.com>
 <201208151434.05145.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151434.05145.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:34:04PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +#ifdef CONFIG_AARCH32_EMULATION
> > +#include <linux/compat.h>
> > +
> > +#define AARCH32_KERN_SIGRET_CODE_OFFSET	0x500
> > +
> > +extern const compat_ulong_t aarch32_sigret_code[6];
> > +
> > +int compat_setup_frame(int usig, struct k_sigaction *ka, sigset_t *set,
> > +		       struct pt_regs *regs);
> > +int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
> > +			  sigset_t *set, struct pt_regs *regs);
> > +
> > +void compat_setup_restart_syscall(struct pt_regs *regs);
> > +#else
> > +
> > +static inline int compat_setup_frame(int usid, struct k_sigaction *ka,
> > +				     sigset_t *set, struct pt_regs *regs)
> > +{
> > +	BUG();
> > +}
> 
> What good is the run-time BUG() here? Nothing should be calling these
> when CONFIG_COMPAT is disabled, so I think you should just remove
> the #ifdef around the declarations, and the entire #else case.

They are called from handle_signal(), so that's to avoid #ifdef inside
functions. I can drop the BUG() (but keep the empty function) and
change the checks to is_compat_task() so that the compiler optimises the
condition out when !COMPAT.

-- 
Catalin
