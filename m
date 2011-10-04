Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1JDA5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:57:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59148 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752170Ab1JDA5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:57:49 -0400
Message-ID: <1317689868.13927.26.camel@Joe-Laptop>
Subject: Re: [PATCH 3/9] Staging: comedi: fix printk issue in cb_pcidas.c
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>,
        devel@driverdev.osuosl.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Oct 2011 17:57:48 -0700
In-Reply-To: <4E8A457F.5050106@gmail.com>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
	 <1317388707-1980-3-git-send-email-ravishankar.km@greenturtles.in>
	 <4E8A457F.5050106@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 10:30 +1100, Ryan Mallon wrote:
> On 30/09/11 23:18, Ravishankar Karkala Mallikarjunayya wrote:
> 
> > This is a patch to the cb_pcidas.c file that fixes up a printk warning found by the checkpatch.pl tool
> > 
> > Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> > ---
> >  drivers/staging/comedi/drivers/cb_pcidas.c |   21 +++++++++++++--------
> >  1 files changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
> > index 9dec153..9d16c6c 100644
> > --- a/drivers/staging/comedi/drivers/cb_pcidas.c
> > +++ b/drivers/staging/comedi/drivers/cb_pcidas.c
> > @@ -565,7 +565,8 @@ static int cb_pcidas_attach(struct comedi_device *dev,
> >  	int index;
> >  	int i;
> >  
> > -	pr_info("comedi%d: cb_pcidas: ", dev->minor);
> > +	dev_info(&pcidev->dev, "comedi%d: cb_pcidas:\n",
> > +		dev->minor);
> 
> This printk can probably be removed now. It's just noise. Similar in
> other places too.

Looking a bit further at the patch and the function it
modifies, it converts dev->minor to &pcidev->dev.  In the
function, pcidev is initialized to NULL a couple of lines
before the dev_info so this proposed patch is truly broken.

I've now officially given up looking at comedi printk cleanups.

Most of the proposed patches have very high error rates and
the submitters don't seem to want to improve their submissions
or lower their error rate significantly.

I could probably fix the whole thing correctly in an afternoon.

I'd add and use comedi_<level> functions that Greg doesn't like
and until Greg changes his mind, I won't bother.


