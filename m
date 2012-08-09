Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2HIHtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:49:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58628 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2HIHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:49:21 -0400
Date: Thu, 9 Aug 2012 08:47:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] ARM: rpc: Fix building RiscPC
Message-ID: <20120809074754.GP18957@n2100.arm.linux.org.uk>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344461278-28245-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 11:27:57PM +0200, Arnd Bergmann wrote:
> ARMv3 support was removed in 357c9c1f07 "ARM: Remove support for ARMv3
> ARM610 and ARM710 CPUs", which explicitly left parts of the CPU32v3
> support in place for building RiscPC. However, this does not actually
> build in my test setup.
> 
> This is probably not the right solution, but maybe someone has a better
> idea for how to deal with this.

This isn't the right solution.  The RiscPC bus does not support half-word
load/stores, so we must continue to build that target for the 32v3
architecture (which is why I carefully left that stuff behind.)

The mistake is in what I did with arch/arm/lib - the armv3 code in there
needs to be resurected instead.
