Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1HCH0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 03:26:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49099 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1HCH0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 03:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110802081129.b84a7bc7.rdunlap@xenotime.net>
References: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com>
	<20110802081129.b84a7bc7.rdunlap@xenotime.net>
Date: Wed, 3 Aug 2011 09:20:48 +0200
X-Google-Sender-Auth: zshImYY7NHOUPvG5vCrzvE0e4aI
Message-ID: <CAMuHMdUNh8tYrVn60aHY2dZ1jZNbBrhe_+V5AVxBTZqnTvH__A@mail.gmail.com>
Subject: Re: [PATCH] pti: add missing CONFIG_PCI dependency
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 17:11, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Tue, 2 Aug 2011 10:08:34 +0200 Heiko Carstens wrote:
>
>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> allmodconfig compile fails on s390 because of the new PTI driver:
>>
>> drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
>> drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'
>>
>> Add a 'depends on PCI' statement so it doesn't get compiled.
>>
>> Cc: J Freyensee <james_p_freyensee@linux.intel.com>
>
> James has already acked my identical patch.
> The problem seems to be that we don't have a drivers/misc/ maintainter to
> merge the patch.
>
> Anyway:
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

It's also missing

#include <linux/slab.h>
#include <linux/uaccess.h>

Cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/4429212/

drivers/misc/pti.c:249: error: implicit declaration of function 'kmalloc'
drivers/misc/pti.c:657: error: implicit declaration of function 'copy_from_user'
drivers/misc/pti.c:848: error: implicit declaration of function 'kzalloc'

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
