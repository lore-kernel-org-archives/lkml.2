Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1GHUHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 16:07:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60411 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1GHUHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 16:07:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110707093202.a831fce8.randy.dunlap@oracle.com>
References: <20110704170952.1024e89b.sfr@canb.auug.org.au>
	<20110704134541.9adfd4f1.randy.dunlap@oracle.com>
	<20110707081441.a4a64e59.randy.dunlap@oracle.com>
	<4E15DF07.4010507@linux.intel.com>
	<20110707093202.a831fce8.randy.dunlap@oracle.com>
Date: Fri, 8 Jul 2011 22:07:08 +0200
X-Google-Sender-Auth: o8aT7sjbJOFb6fubLB2KkX0gqmE
Message-ID: <CAMuHMdV_kgfM2bEmHw8u8c3js7EK7BLmd2yzoip3rjOPAWUQ2Q@mail.gmail.com>
Subject: Re: linux-next: Tree for July 4 (misc/pti)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 18:32, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 07 Jul 2011 09:29:59 -0700 J Freyensee wrote:
>> On 07/07/2011 08:14 AM, Randy Dunlap wrote:
>> > On Mon, 4 Jul 2011 13:45:41 -0700 Randy Dunlap wrote:
>> >> On Mon, 4 Jul 2011 17:09:52 +1000 Stephen Rothwell wrote:
>> >>> Changes since 20110701:
>> >> when CONFIG_PCI is not enabled:
>> >>
>> >> drivers/misc/pti.c:410: error: implicit declaration of function 'pci_release_region'
>> >> drivers/misc/pti.c:859: error: implicit declaration of function 'pci_request_region'
>> >>
>> >> Stubs for these 2 functions could be added to include/linux/pci.h, but it would
>> >> make more sense to me just to make the driver depend on PCI since it seems to rely
>> >> on so many PCI functions.  or are the PCI pieces optional?
>> >
>> > ping.  still a problem in linux-next 20110706.
>>
>> Thanks for the ping.
>>
>> Is there something you need me to do or look at?
>>
>> For Intel-Atom architectures, the MIPI PTI module does sit on the PCI
>> bus.  It's very much dependent upon the PCI bus for working
>> functionality and it's not optional.  So yes, it makes sense for the
>> driver to depend on PCI to be there and if PCI is not enabled on the
>> system, don't build the pti driver.
>>
>> Maybe it's a Kconfig dependency?
>
> Yes, please send/merge a patch that adds
>        depends on PCI
> to "config INTEL_MID_PCI".

http://kisskb.ellerman.id.au/kisskb/buildresult/4292241/:

drivers/misc/pti.c:249: error: implicit declaration of function 'kmalloc'
drivers/misc/pti.c:258: error: implicit declaration of function 'kfree'
drivers/misc/pti.c:657: error: implicit declaration of function 'copy_from_user'
drivers/misc/pti.c:848: error: implicit declaration of function 'kzalloc'

Probably missing

#include <linux/slab.h>
#include <linux/uaccess.h>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
