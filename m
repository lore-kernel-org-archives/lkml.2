Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab0JJFNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 01:13:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33625 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0JJFN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 01:13:29 -0400
Date: Sat, 9 Oct 2010 23:13:24 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] sparc: stop exporting openprom.h header
Message-ID: <20101010051324.GA9292@angua.secretlab.ca>
References: <20101008173650.GH3863@angua.secretlab.ca>
 <20101008.104557.59696706.davem@davemloft.net>
 <20101008113424.2249c2df@debxo>
 <20101008.115226.179923658.davem@davemloft.net>
 <AANLkTikuaM5VZadCs302HwYYhOHi1Czw2BLam3ZQP=aj@mail.gmail.com>
 <20101008143450.1334d8df@debxo>
 <20101009085143.GA1595@angua.secretlab.ca>
 <20101009134808.47723524@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101009134808.47723524@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 01:48:08PM -0700, Andres Salomon wrote:
> On Sat, 9 Oct 2010 02:51:43 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > On Fri, Oct 08, 2010 at 02:34:50PM -0700, Andres Salomon wrote:
> > > On Fri, 8 Oct 2010 13:00:25 -0600
> > > Grant Likely <grant.likely@secretlab.ca> wrote:
> > > 
> > > > On Fri, Oct 8, 2010 at 12:52 PM, David Miller
> > > > <davem@davemloft.net> wrote:
> > > > > From: Andres Salomon <dilinger@queued.net>
> > > > > Date: Fri, 8 Oct 2010 11:34:24 -0700
> > > > >
> > > > >>
> > > > >> It's unknown why openprom.h was being exported; there doesn't
> > > > >> seem to be any reason for it currently, and it creates
> > > > >> headaches with userspace being able to potentially use the
> > > > >> structures in there. So, don't export it anymore.
> > > > >>
> > > > >> Signed-off-by: Andres Salomon <dilinger@queued.net>
> > > > >
> > > > > Acked-by: David S. Miller <davem@davemloft.net>
> > > > 
> > > > I suppose it makes sense for me to pick this one up into my tree
> > > > so it is grouped with the rest of the pdt patches.  I'll pick it
> > > > up once Andres reposts the series.
> > > > 
> > > > g.
> > > 
> > > Ok, I sent a new version of the phandle stuff (which was easier than
> > > expected, and doesn't affect any other patches).
> > > 
> > > So to summarize, what's pending is:
> > > 
> > > 1- https://patchwork.kernel.org/patch/242041/ (sparc: stop exporting
> > >    openprom.h header)
> > >    Acked by Dave
> > > 
> > > 2- https://patchwork.kernel.org/patch/242601/ ([v3] sparc: convert
> > >    various prom_* functions to use phandle)
> > >    Acked by Dave
> > > 
> > > 3- https://patchwork.kernel.org/patch/141011/ (sparc: break out some
> > >    PROM device-tree building code out into drivers/of)
> > >    Acked by Dave
> > > 
> > > 4- https://patchwork.kernel.org/patch/141021/ (sparc: make
> > >    drivers/of/pdt.c no longer sparc-only)
> > >    Acked by Dave
> > > 
> > > 5- https://patchwork.kernel.org/patch/141031/ (of: no longer call
> > > prom_ functions directly; use an ops structure)
> > >    Acked by Dave
> > > 
> > > 6- https://patchwork.kernel.org/patch/141041/ (of: add
> > >    of_pdt namespace to pdt code)
> > >    Acked by Dave
> > > 
> > > 7- https://patchwork.kernel.org/patch/141051/ (of: add
> > > package-to-path support to pdt)
> > 
> > I've picked up 1-7 and am build testing now.

Hmmm, series fails to build on sparc32, and doesn't appear to be
fully bisectable.  Patches 1-3 compile file.  Adding patch 4 gives
the following build error.  Missing include perhaps?

/home/grant/hacking/linux-2.6/drivers/of/pdt.c: In function 'build_one_prop':
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:80: error: implicit declaration of function 'prom_firstprop'
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:80: warning: assignment makes pointer from integer without a cast
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:82: error: implicit declaration of function 'prom_nextprop'
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:82: warning: assignment makes pointer from integer without a cast
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:92: error: implicit declaration of function 'prom_getproplen'
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:99: error: implicit declaration of function 'prom_getproperty'
/home/grant/hacking/linux-2.6/drivers/of/pdt.c: In function 'prom_build_tree':
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:213: error: implicit declaration of function 'prom_getchild'
/home/grant/hacking/linux-2.6/drivers/of/pdt.c:218: error: implicit declaration of function 'prom_getsibling'
distcc[16086] ERROR: compile /home/grant/hacking/linux-2.6/drivers/of/pdt.c on localhost failed
make[3]: *** [drivers/of/pdt.o] Error 1
make[2]: *** [drivers/of] Error 2
make[2]: *** Waiting for unfinished jobs....

And after applying patch 5, I get this instead:

cc1: warnings being treated as errors
/home/grant/hacking/linux-2.6/arch/sparc/kernel/prom_common.c: In function 'prom_common_nextprop':
/home/grant/hacking/linux-2.6/arch/sparc/kernel/prom_common.c:144: error: passing argument 2 of 'prom_nextprop' discards qualifiers from pointer target type
/home/grant/hacking/linux-2.6/arch/sparc/include/asm/oplib_32.h:227: note: expected 'char *' but argument is of type 'const char *'
make[2]: *** [arch/sparc/kernel/prom_common.o] Error 1
make[2]: *** Waiting for unfinished jobs....

And applying the subsequent patches fails with the same error.
Sparc64 builds fine with the entire stack applied, but I haven't
bisected and I suspect that patch 4 will still fail there.

So, I'll leave patches 1-3 in my tree, and drop 4-7 until you get it
sorted out.

> > > 8- https://patchwork.kernel.org/patch/141071/ (x86: OLPC: add OLPC
> > >    device-tree support)
> > 
> > I'm not happy about the /proc/devicetree stuff in this patch.  I would
> > rather see the proc_device_tree_init() call moved to initcall time
> > so that the need for an of_pdt_init_devicetree() hook goes away, but
> > there are a number of gotchas for dynamic tree users that I need to
> > investigate.  Anyway, I'll get 1-7 tested and into linux-next while I
> > think about patch 8.
> > 
> 
> I'm failing to see why it's a problem to have the hook (which could
> just as easily be a generic proc_root_init_prepare hook called from
> proc_root_init(), allowing usage by various other subsystems), but
> okay.

I'm not a fan of global hooks and I personally feel that having to
resort to them is usually failure in architecture.  That said, I'm
beginning to worry that the alternative will require a non-trivial
refactoring of the proc devicetree code.

> I'm not that familiar w/ the dynamic tree stuff; do you imagine this
> being an invasive change, or will it be as simple as just deferring the
> init call?

I had hoped that it would be as simple as deferring the init call, but
I started pulling at that thread, and I suspect the proc devicetree
has some rather important ordering issues that I don't fully
appreciate yet.  I also suspect that some of the logic to keep the
live tree and the proc tree synchronized is scattered outside of the
core OF code.  Blech.  I'm still investigating, but please include
patch 8 when you repost to resolve the build issue.

g.
