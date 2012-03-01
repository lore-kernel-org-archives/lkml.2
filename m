Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab2CALtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:49:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2CALty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:49:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: at91: Error while registering DMA controller in 3.3-rc
Date: Thu, 1 Mar 2012 11:49:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4F4F49E1.4020902@atmel.com>
In-Reply-To: <4F4F49E1.4020902@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203011149.42948.arnd@arndb.de>
X-Provags-ID: V02:K0:/ZP4tf9JQPQlyuyqi/1nat5NhMM8vVjSCGEMsXS4Dtc
 NEOms8TfyZlPwcUQgBlAERPr75k29zd5MnqPSW9ei/SAv4XYdB
 8gZRzUYK4CHUweYY+xcGQ6X+QWrOpDfGtkKqZNWLezlyMauvIT
 BwH0p9X2QfrOaMrUMIvmJqrfuI0Zy737qJ+WPmrtNjSvW+YoKo
 8raOt8PGA6yyZH6iTceh4GdJTaxcn3zzp/bTZkG4w/cS7wLYEU
 rQ05SMt8xFUfp7zVgqcSqRzD6h6ugKzvCB34JS7D8NTqvqMhd4
 5OlxESiea5rn0Wtlj4Px05tyiTr3T3Q2HT3afbB7RRwl9D9DAR
 juPvDajDaWVlX3wZUiKU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Nicolas Ferre wrote:
> We currently have a regression on 3.3-rc kernels about the DMA
> controller registration.
> 
> http://article.gmane.org/gmane.linux.kernel.mmc/13014
> 
> This is due to the DMA driver having seen an update during the 3.3 merge
> window  but the AT91 device files not having the corresponding
> modifications.
> 
> Maybe you remember, those modifications where part of the famous AT91
> board/device series that was postponed to 3.4 due to a flood of issues...
> 
> So now, I would like to know if it is possible to resolve this problem
> by queuing the DMA related patches that we have already in
> at91/device-board branch to mainline before 3.3-final?

Yes, that should be possible. We try not have the same patches in multiple
branches, but since this is a regression, I think we should do it anyway.

> The patches that I am talking about are:
> 
> bdad0b9 ARM: at91/dma: remove platform data from DMA controller
> and
> 2756bf5 ARM: at91/dma: DMA controller registering with DT support
> 
> I do think it is pretty silly to try to resolve this issue by not taking
> those two little patches and modifying source code to workaround this
> issue. If we do this, we will get conflicts and need to rework the
> already queued 3.4 material.
> 
> Do you want me to prepare a new at91-fixes branch with those two patches
> or you can take them yourself?

Better send me a pull request so that you can do some testing on the
exact branch that you send me. I would probably end up with the
same tree and I'm not worried about doing it, but we should make sure
that it actually works.

	Arnd
