Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2IRVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:25:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab2IRVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:25:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 08+09/24] ARM: ixp4xx: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 21:25:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Imre Kaloz <kaloz@openwrt.org>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-10-git-send-email-arnd@arndb.de> <m3ehlzdr9d.fsf_-_@intrepid.localdomain>
In-Reply-To: <m3ehlzdr9d.fsf_-_@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209182125.44494.arnd@arndb.de>
X-Provags-ID: V02:K0:Zn+XpPw2c+mkibZ7VFoLPZ8epbqNKy8/nm1DvKMdFfR
 eadi4wTdSlsyIMcQV1diQxUBSdP7YezhEhxesSRmSDzvUHNjut
 qSEUSXyPWFnqv7eWJcIdmGMJAXejnSS7NUwnBqbR7RIbNeseMC
 M84pwRX2oMxpiAIUOvFfzJ4/GuwBg0ec3UXq/DK2Y2/uLiNAzO
 8nSA+iQniudslYkyhGunZan+75Qj7LU/ZGvPV6n98fdBwA47nc
 KNG2FB870x6PDSiZydg3ulig+r8tV2aBg8u/RsA00OANN4/g94
 +0kFAYewNjGgBoNbG1JprwnekhP1RGBm92O0HPYIHDW9Pc+tlx
 wGwTOC8QxKp2KowRxHhk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Krzysztof Halasa wrote:
> > @@ -51,7 +52,7 @@ static inline u32 ixp4xx_read_feature_bits(void)
> >  
> >  static inline void ixp4xx_write_feature_bits(u32 value)
> >  {
> > -     *IXP4XX_EXP_CFG2 = ~value;
> > +     __raw_writel(~cpu_to_le32(value), IXP4XX_EXP_CFG2);
> >  }
> 
> The EXP_CFG2 register is already in host order, no need for
> cpu_to_le32() as the replaced code clearly shows.
> 
> Can you merge both IXP4xx parts (in the two patches) and fix the above,
> please? Thanks.

Thanks for pointing this out, that was a mistake on my end, because I first
tried to convert to writel, with byteswap and then made up my mind and used
__raw_writel instead because it seemed silly to do two byteswaps.

	Arnd
