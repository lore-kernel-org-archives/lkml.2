Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0EaVIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:08:14 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:49130 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0EaVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ZTVyN6UzF1tf+4Rt1OzDJrHZYuET0gX9OdjLP1W5Kk6KUTWckJojBC2skDgvSmshzH
         epx5klL7MgOpECyAAbbZCJZ9g1Wam7F/vrOwNx1kK2voicwYpj3J8FSC5mtKA8gAE473
         bJkkIGc8/r27pMEzy4j6RVWh+eCegf0fR6UIY=
Date: Mon, 31 May 2010 23:07:48 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] input/tps6507x-ts: zero vs NULL
Message-ID: <20100531210748.GB5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Todd Fischer <todd.fischer@ridgerun.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20100531120215.GS5483@bicker> <20100531191029.GD30712@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531191029.GD30712@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 12:10:29PM -0700, Dmitry Torokhov wrote:
> On Mon, May 31, 2010 at 02:02:15PM +0200, Dan Carpenter wrote:
> > --- a/drivers/input/touchscreen/tps6507x-ts.c
> > +++ b/drivers/input/touchscreen/tps6507x-ts.c
> > @@ -342,7 +342,7 @@ err2:
> >  	cancel_delayed_work(&tsc->work);
> >  	flush_workqueue(tsc->wq);
> >  	destroy_workqueue(tsc->wq);
> > -	tsc->wq = 0;
> > +	tsc->wq = NULL;
> >  	input_free_device(input_dev);
> >  err1:
> >  	kfree(tsc);
> > @@ -364,7 +364,7 @@ static int __devexit tps6507x_ts_remove(struct platform_device *pdev)
> >  	cancel_delayed_work(&tsc->work);
> >  	flush_workqueue(tsc->wq);
> 
> Why isn't it cancel_delayed_work_sync()?
> 

Good point.

> >  	destroy_workqueue(tsc->wq);
> > -	tsc->wq = 0;
> > +	tsc->wq = NULL;
> >  
> 
> Setting tsc to 0/NULL does not make much sense as it is being freed a
> couple of lines below.
> 

That's true.  I'll send an updated patch tomorrow.

regards,
dan carpenter
