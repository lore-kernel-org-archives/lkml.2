Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1E3J1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:27:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:45799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1E3J1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:27:17 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 30 May 2011 10:27:08 +0100
In-Reply-To: <20110530091536.GA2827@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
	 <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530091536.GA2827@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306747629.2029.397.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 11:15 +0200, Ingo Molnar wrote:
> 
> > I believe that this 'filtered randconfig' behaviour is now fairly much
> > the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'.
> 
> I use "make ARCH=i386 defconfig" and "make ARCH=x86_64 defconfig" all 
> the time.

Good point. But shouldn't "make i386_defconfig" and "make
x86_64_defconfig" do that?

They *don't*, but I think that's just a bug:

[dwmw2@i7 iommu-2.6]$ make V=1 i386_defconfig
make -f scripts/Makefile.build obj=scripts/basic
rm -f .tmp_quiet_recordmcount
mkdir -p include/linux include/config
make -f scripts/Makefile.build obj=scripts/kconfig i386_defconfig
scripts/kconfig/conf --defconfig=arch/x86/configs/i386_defconfig Kconfig
gr#
# configuration written to .config
#
[dwmw2@i7 iommu-2.6]$ grep defconfig .config
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"

-- 
dwmw2

