Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3AGBLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:11:51 -0500
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:40766 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984Ab3AGBLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:11:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAMoe6lBlqTCu/2dsb2JhbAANOL1sgxEBAQEEOEABEAsNCwkWDwkDAgECAUUGDQEHAQGIAAEepX6Pd5EVA5cnhHGNQg
X-IronPort-AV: E=Sophos;i="4.84,421,1355068800"; 
   d="scan'208";a="299426320"
Message-ID: <50EA20CF.7050601@westnet.com.au>
Date: Mon, 07 Jan 2013 11:11:43 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: Re: m68k nommu: build failure in v3.8-rc2
References: <20130106122626.GA15524@netboy.at.omicron.at>
In-Reply-To: <20130106122626.GA15524@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 01/06/2013 10:26 PM, Richard Cochran wrote:
> I see the following error, using the .config inline, below.
>
> arch/m68k/mm/init.c: In function 'print_memmap':
> arch/m68k/mm/init.c:139:2: error: 'KMAP_START' undeclared (first use in this function)
> arch/m68k/mm/init.c:139:2: note: each undeclared identifier is reported only once for each function it appears in
> arch/m68k/mm/init.c:139:2: error: 'KMAP_END' undeclared (first use in this function)
>
> Looks to me like KMAP_START is only meant for the MMU case. This error
> was possibly caused by one of these two patches.
>
> $ pr v3.7.. -- arch/m68k/mm/init.c
> f50bf88 m68k: move to a single instance of free_initmem()
> dd1cb3a m68k: merge MMU and non-MMU versions of mm/init.c
>
> What is the right fix for this?

This is the planned fix:

http://marc.info/?l=linux-m68k&m=135088484810474&w=2

Well actually it was meant to go in before the above changes. I
have it queued to go to Linus soon. Just awaiting another fix
for non-mmu 68000 build issues so I can send them all together.

Regards
Greg


> ---
> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/m68k 3.8.0-rc2 Kernel Configuration
> #
> CONFIG_M68K=y
> CONFIG_RWSEM_GENERIC_SPINLOCK=y
> CONFIG_GENERIC_GPIO=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_GENERIC_CSUM=y
> CONFIG_TIME_LOW_RES=y
> CONFIG_NO_IOPORT=y
> # CONFIG_NO_DMA is not set
> CONFIG_ZONE_DMA=y
> CONFIG_HZ=100
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SYSVIPC is not set
> # CONFIG_POSIX_MQUEUE is not set
> # CONFIG_FHANDLE is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
>


