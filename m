Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2AJHpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:45:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39547 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2AJHpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:45:33 -0500
Date: Mon, 9 Jan 2012 23:45:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Milton Miller <miltonm@bga.com>
Cc: Che-Liang Chiou <clchiou@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20120110074520.GA19930@core.coreip.homeip.net>
References: <20120110061735.9BD676BA98@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110061735.9BD676BA98@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:17:35PM -0800, Milton Miller wrote:
> Subject	Re: [PATCH 1/2] Input: serio_raw - cosmetic fixes
> In-Reply-To: <20120109082412.GC4049@core.coreip.homeip.net>
> References: <20120109082412.GC4049@core.coreip.homeip.net>
> 	<1325847795-30486-1-git-send-email-clchiou@chromium.org>
> Date: Tue, 10 Jan 2012 00:14:35 -0600
> Subject: (No subject header)
> X-Originating-IP: 71.22.127.106
> Message-ID: <1326176075_1502@mail4.comsite.net>
> 
> On Mon, 9 Jan 2012 about 00:24:12 -0800, Dmitry Torokhov wrote:
> > >  	struct serio_raw_client *client = file->private_data;
> > >  	struct serio_raw *serio_raw = client->serio_raw;
> > > -	unsigned int mask;
> > > 
> > >  	poll_wait(file, &serio_raw->wait, wait);
> > > 
> > > -	mask = serio_raw->dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
> > >  	if (serio_raw->head != serio_raw->tail)
> > >  		return POLLIN | POLLRDNORM;
> > > 
> > 
> > This however is not quite correct. I will be applying the patch below
> > instead.
> > 
> > 
> > diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
> > index ca78a89..c2c6ad8 100644
> > --- a/drivers/input/serio/serio_raw.c
> > +++ b/drivers/input/serio/serio_raw.c
> > @@ -237,7 +237,7 @@ static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
> >  
> >  	mask = serio_raw->dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
> >  	if (serio_raw->head != serio_raw->tail)
> > -		return POLLIN | POLLRDNORM;
> > +		mask |= POLLIN | POLLRDNORM;
> >  
> >  	return 0;
> 
> doesn't this need to be changed to return mask?

Doh! Of course it does.

Thanks.

-- 
Dmitry
