Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2JOS0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:26:41 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:12023 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2JOS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:26:40 -0400
Date: Mon, 15 Oct 2012 20:26:37 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] stk1160: Remove dead code from
 stk1160_i2c_read_reg()
In-Reply-To: <CALF0-+Vtmwu9rCc9BYiDx2O2GQWezK40BYR2LP_ve2YjCt=Afg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1210152025300.1038@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.0811091803320.23782@swampdragon.chaosbits.net> <CALF0-+Vtmwu9rCc9BYiDx2O2GQWezK40BYR2LP_ve2YjCt=Afg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2012, Ezequiel Garcia wrote:

> On Sun, Nov 9, 2008 at 2:04 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > There are two checks for 'rc' being less than zero with no change to
> > 'rc' between the two, so the second is just dead code - remove it.
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/media/usb/stk1160/stk1160-i2c.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
> > index 176ac93..035cf8c 100644
> > --- a/drivers/media/usb/stk1160/stk1160-i2c.c
> > +++ b/drivers/media/usb/stk1160/stk1160-i2c.c
> > @@ -117,9 +117,6 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
> >                 return rc;
> >
> >         stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
> > -       if (rc < 0)
> > -               return rc;
> > -
> >         return 0;
> >  }
> >
> 
> Thanks for doing this. Wouldn't you like to save stk1160_read_reg
> return code to rc, instead of this?
> 
Ahh yes, I guess I was too quick to just assume it was dead code. 
Looking at it again; what you suggest must have been the original 
intention. I'll cook up a new patch.

Thanks.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

