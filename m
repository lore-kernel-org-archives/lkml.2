Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2HORGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:06:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37047 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2HORGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:06:13 -0400
Date: Wed, 15 Aug 2012 10:06:13 -0700
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120815170613.GA2892@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
 <201208151320.02313.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151320.02313.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:20:02PM +0000, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +The AArch64 exception model is made up of a number of exception levels
> > +(EL0 - EL3), with EL0 and EL1 having a secure and a non-secure
> > +counterpart.  EL2 is the hypervisor level and exists only in non-secure
> > +mode. EL3 is the highest priority level and exists only in secure mode.
> 
> I'm always confused by a description like this. It sounds like you cannot
> have a hypervisor if you have code running in secure mode in EL3. What
> I instead understand is that you enter non-secure mode by going from
> EL3 into EL2.
> 
> > +2. Setup the device tree
> > +-------------------------
> > +
> > +Requirement: MANDATORY
> > +
> > +The device tree blob (dtb) must be no bigger than 2 megabytes in size
> > +and placed at a 2-megabyte boundary within the first 512 megabytes from
> > +the start of the kernel image. This is to allow the kernel to map the
> > +blob using a single section mapping in the initial page tables.
> 
> I've seen people put firmware for some peripherals into the device tree,
> so that a device driver can grab a blob from there and load it into the
> device, rather than calling request_firmware() which would fail if the
> OS running on the system does not contain the blob. If such firmware is
> too large, you end up violating the 2 MB limit you impose here.
> 
> Should we keep that limit and declare those use cases as invalid, or
> should we try to make the boot protocol more flexible?
> 
> > diff --git a/arch/arm64/include/asm/setup.h b/arch/arm64/include/asm/setup.h
> > new file mode 100644
> > index 0000000..d766493
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/setup.h
> > @@ -0,0 +1,26 @@
> > +#ifndef __ASM_SETUP_H
> > +#define __ASM_SETUP_H
> > +
> > +#include <linux/types.h>
> > +
> > +#define COMMAND_LINE_SIZE 1024
> > +
> > +#endif
> 
> Is this necessary? The asm-generic version of this file allows 512 bytes,
> which seems plenty.

Chrome OS on my system today uses a 553 character cmdline, in particular
because some of the device mapper arguments are in there (since we boot without
ramdisk). It adds up quickly.

I suggest keeping it common with x86 since those limits are what people
will be used to (2048).


-Olof
