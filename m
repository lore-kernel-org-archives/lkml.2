Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0L3VdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 16:33:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51107 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0L3VdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 16:33:01 -0500
Date: Thu, 30 Dec 2010 14:32:56 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] of/fdt: add kernel command line option for dtb_compat
 string
Message-ID: <20101230213256.GB3220@angua.secretlab.ca>
References: <1291658059-383-1-git-send-email-dirk.brandewie@gmail.com>
 <4bb36a12-8d95-4d4e-936c-c1c74a9372cc@VA3EHSMHS025.ehs.local>
 <4CFD3322.1000503@gmail.com>
 <4CFD3371.3080807@gmail.com>
 <805e9139-7c09-45f5-a5a9-0ed0cbf64f2f@VA3EHSMHS025.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <805e9139-7c09-45f5-a5a9-0ed0cbf64f2f@VA3EHSMHS025.ehs.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 01:50:47PM -0800, Stephen Neuendorffer wrote:
> 
> 
> > -----Original Message-----
> > From: Dirk Brandewie [mailto:dirk.brandewie@gmail.com]
> > Sent: Monday, December 06, 2010 11:03 AM
> > To: Stephen Neuendorffer
> > Cc: linux-kernel@vger.kernel.org; Randy Dunlap;
> devicetree-discuss@lists.ozlabs.org; linux-
> > doc@vger.kernel.org; grant.likely@secretlab.ca
> > Subject: Re: [PATCH] of/fdt: add kernel command line option for
> dtb_compat string
> > 
> > On 12/06/2010 11:01 AM, Dirk Brandewie wrote:
> > > On 12/06/2010 10:37 AM, Stephen Neuendorffer wrote:
> > >>
> > >>
> > >>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> > >>> index c1360e0..ca1318c 100644
> > >>> --- a/drivers/of/fdt.c
> > >>> +++ b/drivers/of/fdt.c
> > >>> @@ -15,6 +15,8 @@
> > >>> #include<linux/of_fdt.h>
> > >>> #include<linux/string.h>
> > >>> #include<linux/errno.h>
> > >>> +#include<asm-generic/vmlinux.lds.h>
> > >>> +
> > >>>
> > >>> #ifdef CONFIG_PPC
> > >>> #include<asm/machdep.h>
> > >>> @@ -604,3 +606,49 @@ void __init unflatten_device_tree(void)
> > >>>
> > >>> pr_debug("<- unflatten_device_tree()\n");
> > >>> }
> > >>> +
> > >>> +extern uint8_t __dtb_start[];
> > >>> +extern uint8_t __dtb_end[];
> > >>> +static void __init *of_flat_dt_find_compatible_dtb(char *name)
> > >>> +{
> > >>> + void *rc = NULL;
> > >>> + unsigned long root, size;
> > >>> + struct boot_param_header *orig_initial_boot_params;
> > >>> + uint8_t *blob;
> > >>> +
> > >>> + orig_initial_boot_params = initial_boot_params;
> > >>> + blob = __dtb_start;
> > >>> + initial_boot_params = (struct boot_param_header *)blob;
> > >>
> > >> Oy... can you avoid the pointer dance by using
> of_fdt_is_compatible()
> > >> from my recent set of patches?
> > >
> > > I would like to get rid of the pointer dance. Is your patch set
> going to make it
> > > into .37? I didn't see any acks.
> > >
> > Obviously I meant .38 :-)
> 
> I'd like it too, but that's up to Grant.  I imagine some of the
> bottleneck is that I don't have
> an easy way to test on powerpc or microblaze at the moment, so it's not
> clear that the code doesn't
> break anything.

It's in my -next branch now.

g.

