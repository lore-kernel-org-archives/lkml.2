Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1JCJta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:49:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49818 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1JCJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:49:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, "Avinash.H.M" <avinashhm@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/30] ARM: omap2+: fix building without i2c
Date: Mon, 03 Oct 2011 11:49:15 +0200
Message-ID: <1443629.oeLM18uNcs@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <alpine.DEB.2.00.1110021928170.4611@utopia.booyaka.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-9-git-send-email-arnd@arndb.de> <alpine.DEB.2.00.1110021928170.4611@utopia.booyaka.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pVsoGOvd7uYNnA+8u9qdxvEHgdksDGTXGQ+x1FHJHHb
 QXboubEBlLZqfHBDQF0O/5CB1pg7jeeU+hoyWxOP1KH40SJcJ9
 5grzlwdK/MdMJ6um+brHRyhEwdEQxsszDSiIcf0mWplew7ycuF
 aXWS9/l3LQVObKTsYhKXS7H8Ozh0onReRPKm90I+5RHbnbvlnc
 vPF66hgtVkA8HjuC65dVaUeJLIyDkRtfhE0cgkyEqZo7Nfqw4M
 FbHxPu9GaPEm4mtFzsxoqWnFrP4Rx1hDm7pV4T9ZRYs32hzYYN
 15b3ptFy3vG08+2uzyJQsIpv3VYNlqCHCIpgzJ3e0BwbAedFOb
 mEDzb+wfQ8Y04u45yPHQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 19:31:25 Paul Walmsley wrote:

> Nice catch.  I think the bug is different, though.  omap_i2c_reset should 
> never be NULL: that code is intended to execute even when 
> CONFIG_I2C_OMAP=n.  The idea is to prevent the IP block from interfering 
> with the rest of the kernel even if the driver is not compiled in, no 
> matter how the bootloader or previous OS programmed the IP block.
> 
> I'd suggest something like the following patch instead.
> 
> 
> - Paul
> 
> From: Paul Walmsley <paul@pwsan.com>
> Date: Sun, 2 Oct 2011 19:15:10 -0600
> Subject: [PATCH] ARM: omap2+: fix build breakage when CONFIG_I2C_OMAP=n
> 
> arch/arm/mach-omap2/Makefile incorrectly skips compilation of the I2C
> IP block reset code when CONFIG_I2C_OMAP=n.  Fix by unconditionally
> compiling arch/arm/mach-omap2/i2c.o, which is needed on all OMAP2+ platforms.
> 
> Problem noted by Arnd Bergmann <arnd@arndb.de>.

Ok, looks better. You should also drop patch 6 "ARM: omap: fix build with
CONFIG_I2C_OMAP disabled" then.

Acked-by: Arnd Bergmann <arnd@arndb.de>

