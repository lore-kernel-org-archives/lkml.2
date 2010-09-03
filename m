Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab0ICKmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:42:44 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:48684 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756809Ab0ICKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:42:41 -0400
Message-ID: <4C80D0E0.9010702@snapgear.com>
Date: Fri, 3 Sep 2010 20:41:36 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andreas Schwab <schwab@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu
 contributions
References: <AANLkTikBLCg_FUwGGiajw3+dgCe6y0s0a1yMs8=A2oCR@mail.gmail.com> <m3vd6nmd68.fsf@hase.home> <19747.1283422807@redhat.com> <20100902102158.19806.14133.stgit@warthog.procyon.org.uk> <m38w3kns4r.fsf@hase.home> <AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com> <3048.1283505520@redhat.com> <4C80C068.1010302@snapgear.com> <7877.1283507577@redhat.com>
In-Reply-To: <7877.1283507577@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 10:41:48.0279 (UTC) FILETIME=[9C5BD070:01CB4B54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/10 19:52, David Howells wrote:
> Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>
>>> Not sure about m68k but m68knommu targets already setup
>>> appropriate -mcpu flags for its various supported CPU types.
>>
>> Same for m68k.
>
> It doesn't seem to:
>
> 	warthog>grep -r mcpu arch/m68k
> 	warthog1>grep -r mtune arch/m68k
> 	warthog1>
>
> I see that m68knommu does:
>
> 	warthog1>grep -r mcpu arch/m68knommu/
> 	arch/m68knommu/Makefile:cflags-$(CONFIG_M5206)          := $(call cc-option,-mcpu=5206,-m5200)
> 	arch/m68knommu/Makefile:cflags-$(CONFIG_M520x)          := $(call cc-option,-mcpu=5208,-m5200)
> 	arch/m68knommu/Makefile:cflags-$(CONFIG_M523x)          := $(call cc-option,-mcpu=523x,-m5307)
> 	...
>
> I guess the m68k compiler I already had doesn't fully support -m5200, since I
> see that, but it doesn't compile some of the instructions when compiling the
> m68knommu defconfig (CONFIG_M520x=y).

Ah, ok, that would explain it. The m520x is one of the newer ColdFire
variants (thus proper cpu=5208 support is only in more recent binutils.
A fallback to -m5200 (which is the absolute minimum ColdFire support)
looks like it is not quite enough here.

Regards
Greg
