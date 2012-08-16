Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2HPKGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:06:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43413 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305Ab2HPKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:05:55 -0400
Date: Thu, 16 Aug 2012 11:05:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/31] arm64: Exception handling
Message-ID: <20120816100536.GF31784@mudshark.cambridge.arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-4-git-send-email-catalin.marinas@arm.com>
 <201208151303.47743.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151303.47743.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 02:03:47PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +#ifdef CONFIG_AARCH32_EMULATION
> > +#define compat_thumb_mode(regs) \
> > +	(((regs)->pstate & COMPAT_PSR_T_BIT))
> > +#else
> > +#define compat_thumb_mode(regs) (0)
> > +#endif
> 
> The symbol we use on other platforms is CONFIG_COMPAT. I don't think you
> need to have a separate CONFIG_AARCH32_EMULATION

Using COMPAT does preclude the possibility of doing something like the x32
ABI later on though. Some other architectures seem to do something similar
(MIPS32_COMPAT, IA32_EMULATION).

Will
