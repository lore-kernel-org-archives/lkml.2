Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2HUIgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:36:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2HUIfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:35:07 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
Date: Tue, 21 Aug 2012 08:34:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <502BC31E.4070200@yahoo.es> <50333982.3020201@yahoo.es> <CAKohpomMPeewDBVxVR=g-op7E53rqt-AZgOdyoib6W+5QsLOOA@mail.gmail.com>
In-Reply-To: <CAKohpomMPeewDBVxVR=g-op7E53rqt-AZgOdyoib6W+5QsLOOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208210834.53544.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:gXH2gj78AHZ/EPOo+JQsjgnNSlR13DRf/Sd/nzN6OgL
 45MOTqpLaJgPKLqMmYXNT3kMccJGT0q0PeTSCbGQDePWt4cN8Z
 iQrtvYwdMnlorjew3B3A30jl6799jgzEusqwedooHI+e7L7nb1
 +IN6JroX+GdpE27rv/MuptE2TGs/H7M1NTZxuV0pgNYHiqBjok
 /9W+JmS55yG1OsH2Ej3DuqwGhTmh9VxgchRbaMQc2Nb3alMmLo
 6U/zwpzZuyJm4uezecpMe6qKA6nFESery9v57RrieviTmHglAN
 zyfFTYBBeMBSTE4Z+TbzK4ID/NKLgkEdctQp8WGiXUL7hyGSar
 jtrUBSR4Ov4KKGlK5mG7AV+ojP2pX+M9IKPSqcWIQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012, Viresh Kumar wrote:
> On 21 August 2012 13:02, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> 
> > On 8/21/2012 2:35 PM, Viresh Kumar wrote:
> >
> > It got swapped as 0xAABB.CCDD => 0xCCDD.AABB
> >
> 
> @Arnd: How do we explain this? shouldn't it be DD CC BB AA??

Yes, this is very strange. Maybe the compiler already splits the
access into two 16-byte loads and that confuses the device?

> > Memory barriers: within the AVR32 code, one often sees explicit ways to
> > introduce memory barriers, e.g.:
> >
> >     hsmc_readl(hsmc, MODE0); /* I/O barrier */
> >
> 
> For ARM it has become a bit complex about using barriers. That's why they
> are added in readl/writel to remove any confusion.

To be more exact: the reason why readl/writel have the barriers is that
device drivers written for x86 expect the barrier semantics to be implied.
ARM also has readl_relaxed/writel_relaxed, which don't have a barrier
against DMA but still enforce ordering between the readl calls (implied
by the CPU architecture).

	Arnd
