Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1IHXSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:18:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1IHXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:18:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-dev@lists.linaro.org
Cc: Mans Rullgard <mans.rullgard@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>, alsa-devel@alsa-project.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Jarkko Nikula <jhnikula@gmail.com>,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform drivers
Date: Thu, 08 Sep 2011 22:28:50 +0200
Message-ID: <3110288.bQbb0H2ME1@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
References: <1315503297-8365-1-git-send-email-mans.rullgard@linaro.org> <CABb+yY0b607kDSGU+trycqQuvGMhC-zpHcv20wjgmEcaK7dz8Q@mail.gmail.com> <CAG5Tg6UOuztenNid1=YbH9a4ZH5MqV4YhohG+r9R+7F=zXs=CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:slPjOmPqXeLPhF/IS1B7PzPMpILItZPKx2bu+ATjDf1
 c84QL6ThuyWl6McVjnoVoyExZjRG/1IDa/H+Nt2ifqvctRJrko
 FGcwhQNyKFKdxB8at2GZpx3lBg/Zfny6Cj4j/u6KqpLuahHHuX
 AKtiHlpMf7fdWpHuGAMA+I4oIDXuJYdt8Q28ttq2dlOqrcFnPq
 Cao9jpFW90a+BvzOPDW8SjcZfHkdTMPZSzw7MtEQpXzSZeLR7W
 fwXJ3wN9sfUq6H0y6hs/NMVSMG9w+zVDbMInhBHBCPrCM2dLiC
 zI8c1MXWXkDGPx0c7UyQijGOzSSL17Tljc1ieuBzG+9ufhNtnF
 2MJANZHTQx5YnnuJZoxI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:05:48 Mans Rullgard wrote:
> >
> > Can't we do by having omap_init_audio() in arch/arm/mach-omap2/devices.c
> > generate a platform device of name depending upon machine_is_* ?
> 
> I had the same thought, but I couldn't find a suitable string anywhere.
> Are you suggesting an if(machine_is_foo()) cascade in omap_init_audio()?
> 
> I'll be the first to agree this patch is not particularly pretty.

My general feeling is that practically every time someone writes
machine_is_*(), they are doing it wrong. There are of course exceptions,
but I would strongly recommend to have the initialization calling up
from the board file into more general functions instead of having all
boards calling the same function which then goes to board specific
code again.

	Arnd
