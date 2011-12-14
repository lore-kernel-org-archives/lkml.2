Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab1LNXyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:54:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37847 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab1LNXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:54:51 -0500
Date: Wed, 14 Dec 2011 23:54:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Denis Kuzmenko <linux@solonet.org.ua>
Cc: Will Deacon <will.deacon@arm.com>, Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [linux-next] make  s5p64x0_defconfig build error
Message-ID: <20111214235436.GG14542@n2100.arm.linux.org.uk>
References: <1323838630.18517.1.camel@phoenix> <20111214123244.GE7122@mudshark.cambridge.arm.com> <20111214191205.GF14542@n2100.arm.linux.org.uk> <4EE93185.9030502@solonet.org.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE93185.9030502@solonet.org.ua>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 01:30:13AM +0200, Denis Kuzmenko wrote:
> On 12/14/2011 09:12 PM, Russell King - ARM Linux wrote:
> > On Wed, Dec 14, 2011 at 12:32:44PM +0000, Will Deacon wrote:
> >> On Wed, Dec 14, 2011 at 04:57:10AM +0000, Axel Lin wrote:
> > So... unless things change, we can expect Gemini, almost all Samsung
> > stuff, shmobile, vt8500, and Telechips TCC8k to be at least broken at
> > the next merge window.
> 
> Mini2440 march (s3c24xx platform) is not broken in v3.2-rc5. Does that
> mean that s3c24xx is untouched by this issue or this means that I should
> use linux-next?

Most of the completed changes are in linux-next for the restart changes.
I have some additional commits (which were posted to the list as the 3rd
sub-series), which I'm not planning to submit in their current form -
they move things _towards_ sorting out the samsung stuff, but they're
all incomplete.  These continue to be a part of my 'reset' branch.

Basically, the comments in the commit summary line marked with XXX need
addressing - and folk need to get out of the habbit of thinking "it's
an include file, it must go into somewhere called 'include'."  Instead,
put includes local to a set of files in a directory in that same
directory.

Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Sun Nov 6 16:22:23 2011 +0000

    ARM: restart: plat-samsung: remove plat/reset.h and s5p_reset_hook

    Now that s5p_reset_hook is unused, we can get rid of plat/reset.h and
    the s5p_reset_hook code in plat/system-reset.h.

    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Sun Nov 6 16:20:11 2011 +0000

    ARM: restart: s5pv210: use new restart hook XXX WIP XXX WHY IS THERE NO LOCAL HEADERS IN arch/arm/mach-exynos4 XXX

    Hook these platforms restart code into the new restart hook rather
    than using arch_reset().

    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Sun Nov 6 13:24:20 2011 +0000

    ARM: restart: exynos4: use new restart hook XXX WIP XXX WHY IS THERE NO LOCAL HEADERS IN arch/arm/mach-exynos4 XXX

    Hook these platforms restart code into the new restart hook rather
    than using arch_reset().

    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

