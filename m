Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2DIV2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:28:44 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:49885 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2DIV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:28:43 -0400
Message-ID: <1334006908.12209.150.camel@dagon.hellion.org.uk>
From: Ian Campbell <ijc@hellion.org.uk>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Date: Mon, 09 Apr 2012 22:28:28 +0100
In-Reply-To: <20120408115920.4d7d2197@sf.home>
References: <20120408115920.4d7d2197@sf.home>
Organization: 
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: arm: CONFIG_ARM_PATCH_PHYS_VIRT=y is broken on kirkwood
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 11:59 +0300, Sergei Trofimovich wrote:
> In order to make the box boot I had to set:
>     CONFIG_EMBEDDED=y
>     # CONFIG_ARM_PATCH_PHYS_VIRT is not set
>    CONFIG_PHYS_OFFSET=0x0
> 
> Do you have an idea why it does not boot anymore by default?

There is a u-boot commit which fixes this issue:

commit 679530278d5a79d34e356ad2d452f4400953bfc2
Author: Michael Walle <[michael@walle.cc]>
Date:   Mon Feb 6 22:42:10 2012 +0530

    arm, arm-kirkwood: disable l2c before linux boot
    
    The decompressor expects the L2 cache to be disabled. This fixes booting
    some kernels, which have CONFIG_ARM_PATCH_PHYS_VIRT enabled.
    
    Signed-off-by: Michael Walle <michael@walle.cc>
    Acked-by: Prafulla Wadaskar <prafulla@marvell.com>
    Cc: Albert ARIBAUD <albert.u.boot@aribaud.net>
    Cc: Prafulla Wadaskar <prafulla@marvell.com>
    Cc: Wolfgang Denk <wd@denx.de>

Ian.

-- 
Ian Campbell


If I can have honesty, it's easier to overlook mistakes.
		-- Kirk, "Space Seed", stardate 3141.9

