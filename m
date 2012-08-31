Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab2HaGYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 02:24:36 -0400
Received: from bosmailout05.eigbox.net ([66.96.187.5]:49277 "EHLO
	bosmailout05.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2HaGYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 02:24:34 -0400
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=EVDLJLhrg0sUKeqAW2r0xw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=AtwVLBwZjNQA:10 a=8nJEP1OIZ-IA:10 a=iTjcqwZce00A:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=EGi62YchvlmY4WP8ziwA:9 a=wPNLvfGTeEIA:10
 a=Kpo39fPXdbgqDwiI3/AEUA==:117
X-EN-OrigOutIP: 10.20.18.10
X-EN-IMPSID: tHhF1j0040D2CUy01HhFDr
Message-ID: <5040488E.307@yahoo.es>
Date: Fri, 31 Aug 2012 13:15:58 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        egtvedt@samfundet.no
CC: spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v2 0/2] dw_dmac: repair driver for use with AVR32 (AP7000)
References: <503F9F72.9020301@yahoo.es> <CAKohponRJHD_7PkQ_W2AF_9YtcRs1sJuQWwZtqmFTSQ-+bQcnQ@mail.gmail.com>
In-Reply-To: <CAKohponRJHD_7PkQ_W2AF_9YtcRs1sJuQWwZtqmFTSQ-+bQcnQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.60.254
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/2012 12:26 PM, Viresh Kumar wrote:
> BTW, Ideally speaking the fix for AVR32 which will enable 32bit mem
> support and enable BIG endian support should have been part of this
> patchset. That code can go through DMA tree as these patches are
> very closely related. Otherwise now you have to wait till these patches
> are included in linux-next, then only you can send AVR32 patches for
> inclusion.
>
> So, maybe you can just add Acked-by from me and Arnd and include
> AVR patches (Only changes related to these two patches) in the same series.
> That will make life easier for you.

Good idea, I already wondered how these 5 patches can be kept together:

1 [PATCH v2 1/2] dw_dmac: make driver endianness configurable
2 [PATCH v2 2/2] dw_dmac: max_mem_width limits value for SRC/DST_TR_WID register
3 [PATCH v2] avr32: at32ap700x: set DMA slave properties for MCI dw_dmac
4 [PATCH v2 1/2] mmc: atmel-mci: DMA can be used with other controller
5 [PATCH v2 2/2] mmc: atmel-mci: AP700x PDC is not connected to MCI

Patch 3 will only compile after patch 2 has been applied.

Patch 4 and 5 will compile but they will only result in a working mci+dma
after patches 1, 2 and 3 have been applied.

I'm a mere  developer, not a MAINTAINER. But sure it would be good to keep
these together as much as possible. It would also be easier for fellow
avr32/mci users who want to upgrade to 3.5.2 without problems.

So I assume that you want patches 1 to 3, packed as [PATCH v3 3/3] ?

The atmel-mci patches will be handled by Ludovic Desroches.


Thanks, Hein
