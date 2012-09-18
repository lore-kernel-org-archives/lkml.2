Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2IRUMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:12:55 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:42705 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2IRUMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:12:48 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH 08+09/24] ARM: ixp4xx: use __iomem pointers for MMIO
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-10-git-send-email-arnd@arndb.de>
Date: Tue, 18 Sep 2012 22:12:46 +0200
In-Reply-To: <1347658492-11608-10-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Fri, 14 Sep 2012 23:34:37 +0200")
Message-ID: <m3ehlzdr9d.fsf_-_@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, there are some minor problems here (both patches merged,
ixp4xx only):

Arnd Bergmann <arnd@arndb.de> writes:

> --- a/arch/arm/mach-ixp4xx/include/mach/cpu.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/cpu.h
> @@ -37,7 +38,7 @@
>  
>  static inline u32 ixp4xx_read_feature_bits(void)
>  {
> -	u32 val = ~*IXP4XX_EXP_CFG2;
> +	u32 val = ~__raw_readl(IXP4XX_EXP_CFG2);
>  

This is all fine, but

> @@ -51,7 +52,7 @@ static inline u32 ixp4xx_read_feature_bits(void)
>  
>  static inline void ixp4xx_write_feature_bits(u32 value)
>  {
> -	*IXP4XX_EXP_CFG2 = ~value;
> +	__raw_writel(~cpu_to_le32(value), IXP4XX_EXP_CFG2);
>  }

The EXP_CFG2 register is already in host order, no need for
cpu_to_le32() as the replaced code clearly shows.

Can you merge both IXP4xx parts (in the two patches) and fix the above,
please? Thanks.
-- 
Krzysztof Halasa
