Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2DXT5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:57:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54652 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab2DXT5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:57:19 -0400
Date: Tue, 24 Apr 2012 20:56:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Message-ID: <20120424195645.GB3628@n2100.arm.linux.org.uk>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 03:05:14PM +0300, Hiroshi DOYU wrote:
> The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> High-performance Bus (AHB) architecture.
> 
> The AHB Arbiter controls AHB bus master arbitration. This effectively
> forms a second level of arbitration for access to the memory
> controller through the AHB Slave Memory device. The AHB pre-fetch
> logic can be configured to enhance performance for devices doing
> sequential access. Each AHB master is assigned to either the high or
> low priority bin. Both Tegra20/30 have this AHB bus.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> Update:
> - Use platform_device to get info from dt dynamically.(Felipe/Arnd)
> ---
>  arch/arm/mach-tegra/Makefile    |    1 +
>  arch/arm/mach-tegra/tegra-ahb.c |  285 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 286 insertions(+), 0 deletions(-)

1. I thought we weren't going to have any more drivers under arch/arm
2. From the way you describe it above, this sounds like it should be some
   kind of generic driver, which obtains the necessary settings to be
   programmed into registers from (eg) DT.
