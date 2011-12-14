Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1LNII3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:08:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52478 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1LNIIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:08:25 -0500
Date: Wed, 14 Dec 2011 08:08:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] Fix kexec reboot on ARM
Message-ID: <20111214080802.GD14542@n2100.arm.linux.org.uk>
References: <w4fwgnhkcd.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w4fwgnhkcd.wl%peter@chubb.wattle.id.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 03:02:10PM +1100, Peter Chubb wrote:
> 
> When kexec() runs, it eventually sets up a 1-to-1 memory map, then
> invokes cpu_reset(). When it invokes cpu_reset (which turns
> off the MMU), it does so at its virtual address.  Across the code that
> disables the MMU, virtual and physical addresses have to be the same,
> otherwise after disabling the MMU, the PC is invalid.
> 
> The simplest fix is to invoke cpu_reset() at its one-to-one mapped
> address.
> 
> I've tested on KZM (arm v6) and Beagleboard (omap)

NAK.

Three reasons:

1. You've not signed-off the patch (please read
   Documentation/SubmittingPatches)
2. pre-ARMv6 do not expect this, and it will break where
   PHYS_OFFSET >= PAGE_OFFSET
3. Have you seen what's already queued for the next merge window?
