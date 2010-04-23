Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0DWGDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 02:03:20 -0400
Received: from www84.your-server.de ([213.133.104.84]:45814 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0DWGDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 02:03:19 -0400
Subject: Re: [PATCH] Fix a huge latency problem in the MTD CFI and LPDDR
 flash drivers.
From: Stefani Seibold <stefani@seibold.net>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1271787391.16051.4.camel@wall-e.seibold.net>
References: <1271623604.7050.0.camel@wall-e.seibold.net>
	 <1271787391.16051.4.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 23 Apr 2010 08:03:04 +0200
Message-ID: <1272002584.5347.2.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

David did not respond to my request since more than a month. Can u apply
the patch to linux next?

Thanks,
Stefani

Am Dienstag, den 20.04.2010, 20:16 +0200 schrieb Stefani Seibold:
> Is the MTD mailing list routed to /dev/null? 
> 
> It is very sad that nobody gives my a reply. 
> 
> I ask for a merge for the patch, and if there any reason why not, it
> would be great to know. Otherwise i can't fix it.
> 
> So again, please merge the path for the huge latency problem.
> 
> Am Sonntag, den 18.04.2010, 22:46 +0200 schrieb Stefani Seibold:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > The use of a memcpy() during a spinlock operation will cause very long
> > thread context switch delays if the flash chip bandwidth is low and the
> > data to be copied large, because a spinlock will disable preemption.
> > 
> > For example: A flash with 6,5 MB/s bandwidth will cause under ubifs,
> > which request sometimes 128 KB (the flash erase size), a preemption delay of
> > 20 milliseconds. High priority threads will not be served during this
> > time, regardless whether this threads access the flash or not. This behavior
> > breaks real time.
> > 
> > The patch changes all the use of spin_lock operations for xxxx->mutex
> > into mutex operations, which is exact what the name says and means.
> > 
> > I have checked the code of the drivers and there is no use of atomic
> > pathes like interrupt or timers. The mtdoops facility will also not be used
> > by this drivers. So it is dave to replace the spin_lock against mutex.
> > 
> > There is no performance regression since the mutex is normally not
> > acquired.
> > 
> > Changelog:
> >  06.03.2010 First release
> >  26.03.2010 Fix mutex[1] issue and tested it for compile failure
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > ---
> >  drivers/mtd/chips/cfi_cmdset_0001.c |  131 +++++++++++++++++-----------------
> >  drivers/mtd/chips/cfi_cmdset_0002.c |  122 ++++++++++++++++----------------
> >  drivers/mtd/chips/cfi_cmdset_0020.c |  136 +++++++++++++++++-----------------
> >  drivers/mtd/chips/fwh_lock.h        |    6 +-
> >  drivers/mtd/chips/gen_probe.c       |    3 +-
> >  drivers/mtd/lpddr/lpddr_cmds.c      |   79 ++++++++++----------
> >  include/linux/mtd/flashchip.h       |    4 +-
> >  7 files changed, 239 insertions(+), 242 deletions(-)
> 


