Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab1AYK3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:29:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43816 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1AYK3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:29:24 -0500
Date: Tue, 25 Jan 2011 10:29:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/19] ARM: Make the argument to virt_to_phys()
	"const volatile"
Message-ID: <20110125102905.GC11507@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-2-git-send-email-catalin.marinas@arm.com> <4D3DD0D8.10905@codeaurora.org> <201101251100.11052.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101251100.11052.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:00:10AM +0100, Arnd Bergmann wrote:
> On Monday 24 January 2011, Stephen Boyd wrote:
> > On 01/24/2011 09:55 AM, Catalin Marinas wrote:
> > > Changing the virt_to_phys() argument to "const volatile void *" avoids
> > > compiler warnings in some situations where this function is used.
> > >
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> > Acked-by: Stephen Boyd <sboyd@codeaurora.org>
> > 
> > Any chance we can get this one patch into 2.6.38? It fixes a warning for
> > MSM.
> 
> Stephen, you might want to have a look at why the warning even appears
> on MSM. Most uses of 'volatile' are misguided, and there could be an
> actual bug in there.

It's actually the right thing - look at x86's definition:

static inline phys_addr_t virt_to_phys(volatile void *address)
