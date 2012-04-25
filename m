Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab2DYNp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:45:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2DYNp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:45:57 -0400
Date: Wed, 25 Apr 2012 14:45:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>, khilman@ti.com,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 11/25] gpio/omap: cleanup omap_gpio_mod_init function
Message-ID: <20120425134508.GE25053@n2100.arm.linux.org.uk>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com> <1328203851-20435-12-git-send-email-tarun.kanti@ti.com> <13629551.hP3ZV1ajDo@vclass> <CAC83ZvK630=6B-k2TfV3XBg8w7ZosLVDNE4ezjDYnn=hcXA48Q@mail.gmail.com> <CAC83ZvJDDvCu8NKTOYh75USA3fvSAKEGaXXi9PtCM955K_keSA@mail.gmail.com> <20120424160447.GI3739@atomide.com> <CAC83Zv+CCLQfZHfqMcbof6JtA-hOK1PfX5Gs0BBVQhBAiWzX_g@mail.gmail.com> <CAMQu2gzwijaSzXprEwTNTie3zCgFcNPonAexzrO_AWc2a8jOkw@mail.gmail.com> <CAC83ZvKN_Qxw-9RPfpJaL5434j0HgysZ364F+b29rdSCQWhm7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC83ZvKN_Qxw-9RPfpJaL5434j0HgysZ364F+b29rdSCQWhm7A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 06:24:14PM +0530, DebBarma, Tarun Kanti wrote:
> On Wed, Apr 25, 2012 at 12:09 PM, Shilimkar, Santosh
> <santosh.shilimkar@ti.com> wrote:
> > On Wed, Apr 25, 2012 at 10:04 AM, DebBarma, Tarun Kanti
> > <tarun.kanti@ti.com> wrote:
> >> On Tue, Apr 24, 2012 at 9:34 PM, Tony Lindgren <tony@atomide.com> wrote:
> >>> * DebBarma, Tarun Kanti <tarun.kanti@ti.com> [120424 08:40]:
> >>>> Hi Janusz,
> >>>>
> >>>> On Tue, Apr 24, 2012 at 12:24 AM, DebBarma, Tarun Kanti
> >>>> <tarun.kanti@ti.com> wrote:
> >>>> > On Sat, Apr 21, 2012 at 7:33 PM, Janusz Krzysztofik
> >>>> > <jkrzyszt@tis.icnet.pl> wrote:
> >>>> >> On Thursday 02 of February 2012 23:00:37 Tarun Kanti DebBarma wrote:
> >>>> >>> With register offsets now defined for respective OMAP versions we can get rid
> >>>> >>> of cpu_class_* checks. This function now has common initialization code for
> >>>> >>> all OMAP versions...
> >>>> >>>
> >>>> >>> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> >>>> >>> Signed-off-by: Charulatha V <charu@ti.com>
> >>>> >>> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>>> >>> Acked-by: Tony Lindgren <tony@atomide.com>
> >>>> >>
> >>>> >> Sorry for being so late with my comment for chanes already present in
> >>>> >> mainline, but this patch breaks GPIO on Amstrad Delta at least, and I
> >>>> >> have neither enough spare time nor enough experience with non OMAP1
> >>>> >> machines to provide a solution myself.
> >>>> > Yes, I looked at the omap_gpio_mod_init() and OMAP1 configurations are
> >>>> > overwritten.
> >>>> > Also looks like there is issue in making distinction between omap15xx
> >>>> > and omap16xx.
> >>>> > I will post a patch and you can help me testing it in OMAP1 platform.
> >>>> > Thanks for pointing this out.
> >>> ...
> >>>
> >>>> Here is the patch, with attachment as well. I have just tested on
> >>>> OMAP4 platform.
> >>>> Testing on other OMAP2+ platforms is pending. In the meantime can you please
> >>>> validate on OMAP1 platform and confirm? Thanks.
> >>>> --
> >>>> Tarun
> >>>>
> >>>> From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> >>>> Date: Tue, 24 Apr 2012 20:34:32 +0530
> >>>> Subject: [PATCH] gpio/omap: fix omap1 register overwrite in omap_gpio_mod_init
> >>>>
> >>>> Initialization of irqenable, irqstatus registers is the common
> >>>> operation done in this function for all OMAP platforms, viz.
> >>>> OMAP1, OMAP2+. The latter _gpio_rmw()'s to irqenable register
> >>>> was overwriting the correctly programmed OMAP1 value at the
> >>>> beginning. As a result, even though it worked on OMAP2+
> >>>> platforms it was breaking OMAP1 functionality.
> >>>
> >>> Sounds like the original patch was never tested on omap1?
> >> That's right, only bootup test was done on OMAP1710-SDP.
> >>
> >>>
> >>>> On closer observation it is found that the first _gpio_rmw()
> >>>> which is supposedly done to take care of OMAP1 platform is
> >>>> generic enough and takes care of OMAP2+ platform as well.
> >>>> Therefore remove the latter _gpio_rmw() to irqenable as they
> >>>> are redundant.
> >>>>
> >>>> Also, changing the sequence and logic of initializing the
> >>>> irqstatus.
> >>>
> >>> Please mention also the breaking commit here and get this fix
> >>> merged as a regression as soon as it's tested for the current
> >>> -rc series.
> >> Sure, I will do that!
> >
> > Looks like it is regression on 3.4 as well so CC stable when you
> > post the patch.
> Ok, I will do that.

Correction.

Don't email your patch in any way to the stable folk _before_ it has been
taken into Linus' tree.  However, you _may_ add in the patch attributations
a Cc: <stable@vger.kernel.org> tag if you want the stable folk to
automatically pick up your patch when it _does_ end up in Linus' tree.
But... make sure that git send-email or whatever doesn't automatically
add that to the recipients for the emailed patch.

If you send the stable people a patch before its in mainline, you'll get
a whinge telling you to read Documentation/stable_kernel_rules.txt
