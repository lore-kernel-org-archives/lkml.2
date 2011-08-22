Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1HVOUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:20:21 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:53830 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab1HVOUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:20:18 -0400
Date: Mon, 22 Aug 2011 16:20:00 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        gregkh@suse.de, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH] drivers:uio:fix section mismatch in uio_pdrv_genirq.c
Message-ID: <20110822141959.GE14373@local>
References: <1313813528-30913-1-git-send-email-wanlong.gao@gmail.com>
 <20110822120314.GC14373@local>
 <1314017441.1825.2.camel@Allen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314017441.1825.2.camel@Allen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added linux-mips to Cc:]

On Mon, Aug 22, 2011 at 08:50:41PM +0800, Wanlong Gao wrote:
> On Mon, 2011-08-22 at 14:03 +0200, Hans J. Koch wrote:
> > On Sat, Aug 20, 2011 at 12:12:07PM +0800, Wanlong Gao wrote:
> > > From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > > 
> > > Remove the __devinitconst to fix the section mismatch.
> > > 
> > > WARNING: drivers/uio/built-in.o(.data+0x2e8): Section mismatch in
> > > reference from the variable uio_pdrv_genirq to the variable
> > 
> > Hmm, I don't see that section mismatch here when I do a
> > make CONFIG_DEBUG_SECTION_MISMATCH=y. How do you produce that?
> 
> I produced in arch of mips like
> make O=../latest ARCH=mips CROSS_COMILE=mips-linux-

That seems to be a MIPS specific problem. It was tested OK on arm and x86.

> 
> > 
> > > .devinit.rodata:uio_of_genirq_match
> > > The variable uio_pdrv_genirq references
> > > the variable __devinitconst uio_of_genirq_match
> > > If the reference is valid then annotate the
> > > variable with __init* or __refdata (see linux/init.h) or name the
> > > variable:
> > > *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
> > > *_console
> > 
> > Is just removing the __devinitconst really the best solution?
> > 
> > Thanks,
> > Hans
> 
> Do you have any better suggestions?

No, maybe the MIPS guys can shed some light on it.

Thanks,
Hans

> 
> Thanks
> -Wanlong Gao
> 
> > 
> > > 
> > > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > > ---
> > >  drivers/uio/uio_pdrv_genirq.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> > > index bae96d2..0b2ed71 100644
> > > --- a/drivers/uio/uio_pdrv_genirq.c
> > > +++ b/drivers/uio/uio_pdrv_genirq.c
> > > @@ -253,7 +253,7 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
> > >  };
> > >  
> > >  #ifdef CONFIG_OF
> > > -static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> > > +static const struct of_device_id uio_of_genirq_match[] = {
> > >  	{ /* empty for now */ },
> > >  };
> > >  MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
> > > -- 
> > > 1.7.4.1
> > > 
> > > 
> 
> 
> 
