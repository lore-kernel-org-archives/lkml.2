Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1HCQEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:04:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:27052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab1HCQEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:04:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,311,1309762800"; 
   d="scan'208";a="35046257"
Message-ID: <4E39717F.6010804@linux.intel.com>
Date: Wed, 03 Aug 2011 09:04:15 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pti: add missing CONFIG_PCI dependency
References: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com> <20110802081129.b84a7bc7.rdunlap@xenotime.net> <CAMuHMdUNh8tYrVn60aHY2dZ1jZNbBrhe_+V5AVxBTZqnTvH__A@mail.gmail.com>
In-Reply-To: <CAMuHMdUNh8tYrVn60aHY2dZ1jZNbBrhe_+V5AVxBTZqnTvH__A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 12:20 AM, Geert Uytterhoeven wrote:
> On Tue, Aug 2, 2011 at 17:11, Randy Dunlap<rdunlap@xenotime.net>  wrote:
>> On Tue, 2 Aug 2011 10:08:34 +0200 Heiko Carstens wrote:
>>
>>> From: Heiko Carstens<heiko.carstens@de.ibm.com>
>>>
>>> allmodconfig compile fails on s390 because of the new PTI driver:
>>>
>>> drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
>>> drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'
>>>
>>> Add a 'depends on PCI' statement so it doesn't get compiled.
>>>
>>> Cc: J Freyensee<james_p_freyensee@linux.intel.com>
>>
>> James has already acked my identical patch.
>> The problem seems to be that we don't have a drivers/misc/ maintainter to
>> merge the patch.
>>
>> Anyway:
>> Acked-by: Randy Dunlap<rdunlap@xenotime.net>
>
> It's also missing
>
> #include<linux/slab.h>
> #include<linux/uaccess.h>
>

Yes, the other patch and url I sent to Greg yesterday will take care of 
that.

Thanks


> Cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/4429212/
>
> drivers/misc/pti.c:249: error: implicit declaration of function 'kmalloc'
> drivers/misc/pti.c:657: error: implicit declaration of function 'copy_from_user'
> drivers/misc/pti.c:848: error: implicit declaration of function 'kzalloc'
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds


-- 
J (James/Jay) Freyensee
Storage Technology Group
Intel Corporation
