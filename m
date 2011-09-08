Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab1IHN7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:59:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45548 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874Ab1IHN7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:59:17 -0400
Date: Thu, 8 Sep 2011 21:58:54 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Marc Dietich <marvin24@gmx.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Greg Kroah-Hartman <gregkh@suse.de>, Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Hans Verkuil <hverkuil@xs4all.nl>,
        Bob Beers <bbeers@gmail.com>, Ralph Loader <suckfish@ihug.co.nz>,
        Tejun Heo <tj@kernel.org>, Greg Dietsche <gregory.dietsche@cuw.edu>,
        Jiri Kosina <jkosina@suse.cz>, Vitaliy Ivanov <vitalivanov@gmail.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 25/62] staging: irq: Remove IRQF_DISABLED
Message-ID: <20110908135854.GA3069@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-26-git-send-email-yong.zhang0@gmail.com>
 <201109081240.51212.marvin24@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201109081240.51212.marvin24@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 12:40:48PM +0200, Marc Dietich wrote:
> > This flag is a NOOP and can be removed now.
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > ---
> >  drivers/staging/cx25821/cx25821-alsa.c             |    2 +-
> >  drivers/staging/cx25821/cx25821-audio-upstream.c   |    2 +-
> >  drivers/staging/cx25821/cx25821-core.c             |    2 +-
> >  .../staging/cx25821/cx25821-video-upstream-ch2.c   |    2 +-
> >  drivers/staging/cx25821/cx25821-video-upstream.c   |    2 +-
> >  drivers/staging/cxt1e1/linux.c                     |    6 ------
> >  drivers/staging/lirc/lirc_serial.c                 |    2 +-
> >  drivers/staging/lirc/lirc_sir.c                    |    2 +-
> >  drivers/staging/nvec/nvec.c                        |    2 +-
> >  9 files changed, 8 insertions(+), 14 deletions(-)
> > 
> > [...]
> >
> > diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> > index 72258e8..6210c95 100644
> > --- a/drivers/staging/nvec/nvec.c
> > +++ b/drivers/staging/nvec/nvec.c
> > @@ -339,7 +339,7 @@ static int __devinit tegra_nvec_probe(struct
> > platform_device *pdev)
> > 
> >  	tegra_init_i2c_slave(pdata, i2c_regs, i2c_clk);
> > 
> > -	err = request_irq(nvec->irq, i2c_interrupt, IRQF_DISABLED, "nvec", nvec);
> > +	err = request_irq(nvec->irq, i2c_interrupt, 0, "nvec", nvec);
> >  	if(err) {
> >  		dev_err(nvec->dev, "couldn't request irq");
> >  		goto failed;
> 
> This is already fixed in 
> http://driverdev.linuxdriverproject.org/pipermail/devel/2011-August/018960.html
> which went into the staging tree (which is currently not available).

Thanks for pointing it out.

IMHO, the conflict is easy to fix. And if necessary, I could send a new
version :)

Thanks,
Yong
