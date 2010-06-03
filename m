Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0FCVsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:48:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31878 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab0FCVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:48:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6002"; a="43241298"
Subject: Re: ARM defconfig files
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <20100603181010.GA25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	 <20100603185333.GD25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
	 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
	 <20100603194559.GF25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 14:48:37 -0700
Message-ID: <1275601717.23384.168.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 13:31 -0700, Linus Torvalds wrote:
> and now you'd be able to basically generate a OMAP3EVM .config file by 
> just running "allnoconfig" on that Kconfig.omap3_evm file. But it would 
> only have to select the parts that are specific for the EVM platform, 
> because the generic OMAP3 support would be picked by the Kconfig.omap3 
> file, which in turn would not have to worry about the generic ARM parts 
> etc.
> 
> See?

We could just alias commands so when the user runs

"make ARCH=arm omap3_evm_defconfig"

it would just do whatever this command does ,

"KBUILD_KCONFIG=arch/arm/configs/Kconfig.omap3_evm make allnoconfig"

but those Kconfigs wouldn't be in "make menuconfig" it would just exist
to generate the defconfigs, or the .config .. So Kconfig.omap3_evm
basically becomes the defconfig.

That doesn't seem un-reasonable. Although the solver to me seems more
elegant and we're getting the solver for some other reasons it seems
(unrelated to this defconfig issue).

Daniel


