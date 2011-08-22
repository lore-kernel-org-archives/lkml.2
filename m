Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1HVMux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:50:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34482 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1HVMuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:50:46 -0400
Subject: Re: [PATCH] drivers:uio:fix section mismatch in uio_pdrv_genirq.c
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
In-Reply-To: <20110822120314.GC14373@local>
References: <1313813528-30913-1-git-send-email-wanlong.gao@gmail.com>
	 <20110822120314.GC14373@local>
Content-Type: text/plain; charset="UTF-8"
Organization: FNST
Date: Mon, 22 Aug 2011 20:50:41 +0800
Message-ID: <1314017441.1825.2.camel@Allen>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 14:03 +0200, Hans J. Koch wrote:
> On Sat, Aug 20, 2011 at 12:12:07PM +0800, Wanlong Gao wrote:
> > From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > 
> > Remove the __devinitconst to fix the section mismatch.
> > 
> > WARNING: drivers/uio/built-in.o(.data+0x2e8): Section mismatch in
> > reference from the variable uio_pdrv_genirq to the variable
> 
> Hmm, I don't see that section mismatch here when I do a
> make CONFIG_DEBUG_SECTION_MISMATCH=y. How do you produce that?

I produced in arch of mips like
make O=../latest ARCH=mips CROSS_COMILE=mips-linux-

> 
> > .devinit.rodata:uio_of_genirq_match
> > The variable uio_pdrv_genirq references
> > the variable __devinitconst uio_of_genirq_match
> > If the reference is valid then annotate the
> > variable with __init* or __refdata (see linux/init.h) or name the
> > variable:
> > *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
> > *_console
> 
> Is just removing the __devinitconst really the best solution?
> 
> Thanks,
> Hans

Do you have any better suggestions?

Thanks
-Wanlong Gao

> 
> > 
> > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > ---
> >  drivers/uio/uio_pdrv_genirq.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> > index bae96d2..0b2ed71 100644
> > --- a/drivers/uio/uio_pdrv_genirq.c
> > +++ b/drivers/uio/uio_pdrv_genirq.c
> > @@ -253,7 +253,7 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
> >  };
> >  
> >  #ifdef CONFIG_OF
> > -static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> > +static const struct of_device_id uio_of_genirq_match[] = {
> >  	{ /* empty for now */ },
> >  };
> >  MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
> > -- 
> > 1.7.4.1
> > 
> > 


