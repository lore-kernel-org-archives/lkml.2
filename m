Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab1LOCpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:45:50 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:50933 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755863Ab1LOCpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:45:49 -0500
Message-ID: <1323917147.29500.9.camel@joe2Laptop>
Subject: Re: [PATCH 30/30] Staging: comedi: fix printk issue in jr3_pci.c
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>,
        gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Dec 2011 18:45:47 -0800
In-Reply-To: <12715.1323915917@turing-police.cc.vt.edu>
References: <1323674539-19307-1-git-send-email-ravishankar.km@greenturtles.in>
	 <12715.1323915917@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 21:25 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 12 Dec 2011 12:52:19 +0530, Ravishankar karkala Mallikarjunayya said:
> > This is a patch to the jr3_pci.c file that fixes up a
> > printk warning found by the checkpatch.pl tool.
[]
> > diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
[]
> > @@ -593,24 +593,24 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
[]
> > +					printk(KERN_DEBUG "%i ", (min_full_scale).fx);
> > +					printk(KERN_CONT "%i ", (min_full_scale).fy);
> > +					printk(KERN_CONT "%i ", (min_full_scale).fz);
> > +					printk(KERN_CONT "%i ", (min_full_scale).mx);
> > +					printk(KERN_CONT "%i ", (min_full_scale).my);
> > +					printk(KERN_CONT "%i ", (min_full_scale).mz);
> > +					printk(KERN_CONT "\n");
> Is there a reason that as long as you were fixing this code, you didn't make it
> one call to printk?
> 					printk(KERN_DEBUG,"%i %i %i %i %i %i\n",
> 						(min_full_scale).fx),
> 						(min_full_scale).fy),
> 						(min_full_scale).fz),
> 						(min_full_scale).mx),
> 						(min_full_scale).my),
> 						(min_full_scale).mz));
> Doing it this way helps guarantee that another CPU doesn't inject a printk into
> the middle and split up your output.
> Also, there should be at least a *short* text string in that printk saying what
> it is.  printk(KERN_DEBUG,"jr3_poll %i"   or similar would be a start.
> Otherwise you get a line with 6 integers in it.

Use #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
and
pr_debug(etc...)

min_full_scale is a variable and doesn't need parenthesis.
It's also in my opinion an overly long name.

					mfs =  get_min_full_scales(channel);
					pr_debug("Got MinFullScales: %i %i %i, %i %i %i\n",
						 msf.fx, msf.fy, msf.fz,
						 msf.mx, msf.my, msf.mz);

> Also, if you're indented that far to the right, that driver is probably in
> serious need of some restructuring or refactoring.

I think 5 tab indentation is a lot but 6 tabs is too many.


