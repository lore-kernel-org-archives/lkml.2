Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0JVMs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:48:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0JVMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:48:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cyril@ti.com
Subject: Re: [PATCH v3 01/12] misc: add driver for sequencer serial port
Date: Fri, 22 Oct 2010 14:48:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
References: <1287694873-12904-1-git-send-email-cyril@ti.com> <20101021161224.b4c0b623.akpm@linux-foundation.org> <4CC18605.80007@ti.com>
In-Reply-To: <4CC18605.80007@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221448.17728.arnd@arndb.de>
X-Provags-ID: V02:K0:h4TsMJdiS1pH11DbiLdjZf8XxlifRAfIdLlywwPv+z/
 s0kM1xm6RazAV3ixOP1W4wbiXjx8cLx+RkhNfQ3U0YzHJOQSv4
 AHx0r8XM7aGEctlLFKuCn5s7xjpbriBtjQhYTzhpvScPISaK+o
 e+tXF2T71NtydE1cal9r1s7kOC7eR5IRfhSVp1AMztDM67x/tc
 Ih44JpmmIaXjQwFinI9Pg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 14:39:33 Cyril Chemparathy wrote:
> >> +/* Register Access Helpers */
> >> +static inline u32 ssp_read(struct ti_ssp *ssp, int reg)
> >> +{
> >> +    return __raw_readl(ssp->regs + reg);
> >> +}
> >> +
> >> +static inline void ssp_write(struct ti_ssp *ssp, int reg, u32 val)
> >> +{
> >> +    __raw_writel(val, ssp->regs + reg);
> >> +}
> > 
> > Why are the __raw functions used here?
> > 
> 
> These registers are to be accessed native endian at all times, and
> therefore the le32 conversion done otherwise is inappropriate.

Won't that break on out-of-order CPUs that need the extra synchronization
done in readl/writel?

	Arnd
