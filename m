Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab0FYXeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:34:23 -0400
Received: from sg2ehsobe001.messaging.microsoft.com ([207.46.51.75]:41549 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992Ab0FYXeW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:34:22 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2010 19:34:22 EDT
X-SpamScore: -26
X-BigFish: VPS-26(zz542N1432N98dN9371Pzz1202hzzz2dh61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
Date: Fri, 25 Jun 2010 16:18:50 -0700
In-Reply-To: <AANLkTilvOpCVrbT4YPaw3NZUCnKgUN7IUQzQGMfihbSG@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
Thread-Index: AcsUvH1G1FFPsvVzS3SME/DE8Pi7GQAAAiXg
References: <20100625220300.6903.3519.stgit@angua> <b392c10f-78bb-466d-a3e0-cf5b95edb4cb@VA3EHSMHS014.ehs.local> <AANLkTilvOpCVrbT4YPaw3NZUCnKgUN7IUQzQGMfihbSG@mail.gmail.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
CC: <benh@kernel.crashing.org>, <monstr@monstr.eu>,
       <microblaze-uclinux@itee.uq.edu.au>,
       <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <jeremy.kerr@canonical.com>, <sfr@canb.auug.org.au>
X-OriginalArrivalTime: 25 Jun 2010 23:19:06.0910 (UTC) FILETIME=[CEFA2BE0:01CB14BC]
X-RCIS-Action: ALLOW
Message-ID: <bb9a6620-ccf1-4f5b-a1cd-97f93bad4baa@SG2EHSMHS007.ehs.local>
X-Reverse-DNS: unknown-60-83.xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> Sent: Friday, June 25, 2010 4:16 PM
> To: Stephen Neuendorffer
> Cc: benh@kernel.crashing.org; monstr@monstr.eu; microblaze-uclinux@itee.uq.edu.au; devicetree-
> discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; jeremy.kerr@canonical.com;
> sfr@canb.auug.org.au
> Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
> 
> On Fri, Jun 25, 2010 at 4:49 PM, Stephen Neuendorffer
> <stephen.neuendorffer@xilinx.com> wrote:
> > Grant,
> >
> > I need this for the PCI project.  I also have a couple of other
> > generalizations of the drivers/of code
> > to get it to run after boot time in an X86 system...
> 
> Send me your patches!  :-)  Get them to me soon and I'll queue them up
> for the next merge window.
> 
> g.

Dangit, I just got the code compiling, and now I find out that X86 doesn't support out_be32()...  :)
You'd think that somewhere somebody might have realized that all the duplicated driver macros that
do that are a bad idea...

Steve

> 
> >
> > Steve
> >
> > Reviewed-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
> >
> >> -----Original Message-----
> >> From:
> > devicetree-discuss-bounces+stephen.neuendorffer=xilinx.com@lists.ozlabs.
> > org [mailto:devicetree-
> >> discuss-bounces+stephen.neuendorffer=xilinx.com@lists.ozlabs.org] On
> > Behalf Of Grant Likely
> >> Sent: Friday, June 25, 2010 3:03 PM
> >> To: benh@kernel.crashing.org; monstr@monstr.eu
> >> Cc: microblaze-uclinux@itee.uq.edu.au;
> > devicetree-discuss@lists.ozlabs.org; linux-
> >> kernel@vger.kernel.org; jeremy.kerr@canonical.com;
> > sfr@canb.auug.org.au
> >> Subject: [PATCH] of/flattree: Use common ALIGN() macro instead of
> > archspecific _ALIGN
> >>
> >> There's no reason to use the powerpc-specific _ALIGN macro in the fdt
> >> code.  Replace it with ALIGN() from kernel.h
> >>
> >> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >> ---
> >>  arch/microblaze/include/asm/page.h |    7 -------
> >>  drivers/of/fdt.c                   |   20 ++++++++++----------
> >>  2 files changed, 10 insertions(+), 17 deletions(-)
> >>
> >> diff --git a/arch/microblaze/include/asm/page.h
> > b/arch/microblaze/include/asm/page.h
> >> index 464ff32..2fd4761 100644
> >> --- a/arch/microblaze/include/asm/page.h
> >> +++ b/arch/microblaze/include/asm/page.h
> >> @@ -39,13 +39,6 @@
> >>  #define PAGE_UP(addr)
> > (((addr)+((PAGE_SIZE)-1))&(~((PAGE_SIZE)-1)))
> >>  #define PAGE_DOWN(addr)      ((addr)&(~((PAGE_SIZE)-1)))
> >>
> >> -/* align addr on a size boundary - adjust address up/down if needed
> > */
> >> -#define _ALIGN_UP(addr, size)
> > (((addr)+((size)-1))&(~((size)-1)))
> >> -#define _ALIGN_DOWN(addr, size)      ((addr)&(~((size)-1)))
> >> -
> >> -/* align addr on a size boundary - adjust address up if needed */
> >> -#define _ALIGN(addr, size)   _ALIGN_UP(addr, size)
> >> -
> >>  #ifndef CONFIG_MMU
> >>  /*
> >>   * PAGE_OFFSET -- the first address of the first page of memory. When
> > not
> >> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> >> index b6987bb..d61fda8 100644
> >> --- a/drivers/of/fdt.c
> >> +++ b/drivers/of/fdt.c
> >> @@ -69,9 +69,9 @@ int __init of_scan_flat_dt(int (*it)(unsigned long
> > node,
> >>                       u32 sz = be32_to_cpup((__be32 *)p);
> >>                       p += 8;
> >>                       if (be32_to_cpu(initial_boot_params->version) <
> > 0x10)
> >> -                             p = _ALIGN(p, sz >= 8 ? 8 : 4);
> >> +                             p = ALIGN(p, sz >= 8 ? 8 : 4);
> >>                       p += sz;
> >> -                     p = _ALIGN(p, 4);
> >> +                     p = ALIGN(p, 4);
> >>                       continue;
> >>               }
> >>               if (tag != OF_DT_BEGIN_NODE) {
> >> @@ -80,7 +80,7 @@ int __init of_scan_flat_dt(int (*it)(unsigned long
> > node,
> >>               }
> >>               depth++;
> >>               pathp = (char *)p;
> >> -             p = _ALIGN(p + strlen(pathp) + 1, 4);
> >> +             p = ALIGN(p + strlen(pathp) + 1, 4);
> >>               if ((*pathp) == '/') {
> >>                       char *lp, *np;
> >>                       for (lp = NULL, np = pathp; *np; np++)
> >> @@ -109,7 +109,7 @@ unsigned long __init of_get_flat_dt_root(void)
> >>               p += 4;
> >>       BUG_ON(be32_to_cpup((__be32 *)p) != OF_DT_BEGIN_NODE);
> >>       p += 4;
> >> -     return _ALIGN(p + strlen((char *)p) + 1, 4);
> >> +     return ALIGN(p + strlen((char *)p) + 1, 4);
> >>  }
> >>
> >>  /**
> >> @@ -138,7 +138,7 @@ void *__init of_get_flat_dt_prop(unsigned long
> > node, const char *name,
> >>               noff = be32_to_cpup((__be32 *)(p + 4));
> >>               p += 8;
> >>               if (be32_to_cpu(initial_boot_params->version) < 0x10)
> >> -                     p = _ALIGN(p, sz >= 8 ? 8 : 4);
> >> +                     p = ALIGN(p, sz >= 8 ? 8 : 4);
> >>
> >>               nstr = find_flat_dt_string(noff);
> >>               if (nstr == NULL) {
> >> @@ -151,7 +151,7 @@ void *__init of_get_flat_dt_prop(unsigned long
> > node, const char *name,
> >>                       return (void *)p;
> >>               }
> >>               p += sz;
> >> -             p = _ALIGN(p, 4);
> >> +             p = ALIGN(p, 4);
> >>       } while (1);
> >>  }
> >>
> >> @@ -184,7 +184,7 @@ static void *__init unflatten_dt_alloc(unsigned
> > long *mem, unsigned long size,
> >>  {
> >>       void *res;
> >>
> >> -     *mem = _ALIGN(*mem, align);
> >> +     *mem = ALIGN(*mem, align);
> >>       res = (void *)*mem;
> >>       *mem += size;
> >>
> >> @@ -220,7 +220,7 @@ unsigned long __init unflatten_dt_node(unsigned
> > long mem,
> >>       *p += 4;
> >>       pathp = (char *)*p;
> >>       l = allocl = strlen(pathp) + 1;
> >> -     *p = _ALIGN(*p + l, 4);
> >> +     *p = ALIGN(*p + l, 4);
> >>
> >>       /* version 0x10 has a more compact unit name here instead of the
> > full
> >>        * path. we accumulate the full path size using "fpsize", we'll
> > rebuild
> >> @@ -299,7 +299,7 @@ unsigned long __init unflatten_dt_node(unsigned
> > long mem,
> >>               noff = be32_to_cpup((__be32 *)((*p) + 4));
> >>               *p += 8;
> >>               if (be32_to_cpu(initial_boot_params->version) < 0x10)
> >> -                     *p = _ALIGN(*p, sz >= 8 ? 8 : 4);
> >> +                     *p = ALIGN(*p, sz >= 8 ? 8 : 4);
> >>
> >>               pname = find_flat_dt_string(noff);
> >>               if (pname == NULL) {
> >> @@ -333,7 +333,7 @@ unsigned long __init unflatten_dt_node(unsigned
> > long mem,
> >>                       *prev_pp = pp;
> >>                       prev_pp = &pp->next;
> >>               }
> >> -             *p = _ALIGN((*p) + sz, 4);
> >> +             *p = ALIGN((*p) + sz, 4);
> >>       }
> >>       /* with version 0x10 we may not have the name property, recreate
> >>        * it here from the unit name if absent
> >>
> >> _______________________________________________
> >> devicetree-discuss mailing list
> >> devicetree-discuss@lists.ozlabs.org
> >> https://lists.ozlabs.org/listinfo/devicetree-discuss
> >
> >
> > This email and any attachments are intended for the sole use of the named recipient(s) and
> contain(s) confidential information that may be proprietary, privileged or copyrighted under
> applicable law. If you are not the intended recipient, do not read, copy, or forward this email
> message or any attachments. Delete this email message and any attachments immediately.
> >
> >
> >
> 
> 
> 
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


