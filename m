Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1GEHzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:55:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14528 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab1GEHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 03:55:39 -0400
Date: Tue, 5 Jul 2011 09:46:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe
In-Reply-To: <20110704173320.GR3021@sortiz-mobl>
Message-ID: <alpine.LNX.2.00.1107050945330.27127@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107022120171.16316@swampdragon.chaosbits.net> <20110704173320.GR3021@sortiz-mobl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011, Samuel Ortiz wrote:

> Hi Jesper,
> 
> On Sat, Jul 02, 2011 at 09:21:38PM +0200, Jesper Juhl wrote:
> > There are a couple of situations where we leak init_data in
> > drivers/mfd/tps65910.c:tps65910_i2c_probe() - this patch should take
> > care of them.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/mfd/tps65910.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> >  Compile tested only.
> > 
> > diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> > index 2229e66..0db62f4 100644
> > --- a/drivers/mfd/tps65910.c
> > +++ b/drivers/mfd/tps65910.c
> > @@ -144,15 +144,17 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
> >  		return -EINVAL;
> >  
> >  	init_data = kzalloc(sizeof(struct tps65910_platform_data), GFP_KERNEL);
> > -	if (init_data == NULL)
> > +	if (!init_data)
> This is not a memory leak fix. And I actually prefer the == NULL check.
> Please remove the == NULL check replacement with !* and keep only the memory
> leak fixing part.
> 
Fair enough. Guess I just made that change out of habit. I'll respin it 
later and send a new patch.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

