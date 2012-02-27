Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2B0UOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:14:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18694 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2B0UOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:14:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 27 Feb 2012 12:14:05 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Feb 2012 12:14:01 -0800
Subject: RE: [PATCH] ARM: boot/compressed/misc.s: Include <linux/bug.h> to
	fix build break
Thread-Topic: [PATCH] ARM: boot/compressed/misc.s: Include <linux/bug.h> to
	fix build break
Thread-Index: Acz1ifFCBvsasGgjRQ26NPTFDaB20QAAf1IQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BD04C@HQMAIL01.nvidia.com>
References: <1330372350-6432-1-git-send-email-swarren@nvidia.com>
 <20120227195637.GE2440@n2100.arm.linux.org.uk>
In-Reply-To: <20120227195637.GE2440@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote at Monday, February 27, 2012 12:57 PM:
> On Mon, Feb 27, 2012 at 12:52:30PM -0700, Stephen Warren wrote:
> > Commmit cf86c17 "kernel.h: doesn't explicitly use bug.h, so don't include
> > it." caused the following build failure on ARM:
> >
> >   CC      arch/arm/boot/compressed/misc.o
> > In file included from arch/arm/boot/compressed/misc.c:28:0:
> > arch/arm/mach-tegra/include/mach/uncompress.h: In function 'arch_decomp_setup':
> > arch/arm/mach-tegra/include/mach/uncompress.h:125:2: error: implicit declaration of function
> 'BUILD_BUG_ON_ZERO' [-Werror=implicit-function-declaration]
> > cc1: some warnings being treated as errors
> 
> Err no.  The decompressor is _not_ part of the kernel, it's a separate
> stand alone environment.  Including randomly kernel headers from the
> rest of the kernel is bad news, particularly if they start calling out
> to external code.
> 
> You should try to keep your uncompress.h as free of other dependencies
> as possible.

OK, It looks like all we need from <linux/kernel.h> is BIT() and
ARRAY_SIZE(). The latter requires <linux/bug.h>. Should I just redefine
those macros in our uncompress.h?

-- 
nvpublic

