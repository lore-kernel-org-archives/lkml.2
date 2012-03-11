Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2CKCnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 21:43:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54102 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2CKCnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 21:43:11 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch] spi: release lock on error path in spi_pump_messages()
To: wharms@bfs.de, Dan Carpenter <dan.carpenter@oracle.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <4F5B2113.3060103@bfs.de>
References: <20120310085729.GB4647@elgon.mountain> <4F5B2113.3060103@bfs.de>
Date: Sat, 10 Mar 2012 19:43:07 -0700
Message-Id: <20120311024307.AA5E33E0950@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012 10:38:27 +0100, walter harms <wharms@bfs.de> wrote:
> 
> 
> Am 10.03.2012 09:57, schrieb Dan Carpenter:
> > We should release the lock here and enable IRQs before returning.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> > index 5ae1e84..ab1bdce 100644
> > --- a/drivers/spi/spi.c
> > +++ b/drivers/spi/spi.c
> > @@ -535,6 +535,7 @@ static void spi_pump_messages(struct kthread_work *work)
> >  			if (ret) {
> >  				dev_err(&master->dev,
> >  					"failed to unprepare transfer hardware\n");
> > +				spin_unlock_irqrestore(&master->queue_lock, flags);
> >  				return;
> >  			}
> >  		}
> 
> 
> hi Dan,
> do you want to protect dev_err() by a spn_lock ?

Applied, after moving unlock above the dev_err.

g.

