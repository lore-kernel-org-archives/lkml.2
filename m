Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab1CUUgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:36:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18997 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1CUUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:36:47 -0400
Date: Mon, 21 Mar 2011 21:36:37 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Matthias Schwarzott <zzam@gentoo.org>
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Patch] Zarlink zl10036 DVB-S: Fix mem leak in zl10036_attach
In-Reply-To: <201102172145.55258.zzam@gentoo.org>
Message-ID: <alpine.LNX.2.00.1103212135530.15815@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102062128391.13593@swampdragon.chaosbits.net> <201102172054.12773.zzam@gentoo.org> <alpine.LNX.2.00.1102172130360.17697@swampdragon.chaosbits.net> <201102172145.55258.zzam@gentoo.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Matthias Schwarzott wrote:

> On Thursday 17 February 2011, Jesper Juhl wrote:
> > On Thu, 17 Feb 2011, Matthias Schwarzott wrote:
> > > On Sunday 06 February 2011, Jesper Juhl wrote:
> > > > If the memory allocation to 'state' succeeds but we jump to the 'error'
> > > > label before 'state' is assigned to fe->tuner_priv, then the call to
> > > > 'zl10036_release(fe)' at the 'error:' label will not free 'state', but
> > > > only what was previously assigned to 'tuner_priv', thus leaking the
> > > > memory allocated to 'state'.
> > > > There are may ways to fix this, including assigning the allocated
> > > > memory directly to 'fe->tuner_priv', but I did not go for that since
> > > > the additional pointer derefs are more expensive than the local
> > > > variable, so I just added a 'kfree(state)' call. I guess the call to
> > > > 'zl10036_release' might not even be needed in this case, but I wasn't
> > > > sure, so I left it in.
> > > 
> > > Yeah, that call to zl10036_release can be completely eleminated.
> > > Another thing is: jumping to the error label only makes sense when memory
> > > was already allocated. So the jump in line 471 can be replaced by
> > > "return NULL",
> > > 
> > > as the other error handling before allocation:
> > >         if (NULL == config) {
> > >         
> > >                 printk(KERN_ERR "%s: no config specified", __func__);
> > >                 goto error;
> > >         
> > >         }
> > > 
> > > I suggest to improve the patch to clean the code up when changing that.
> > > 
> > > But I am fine with commiting this patch also if you do not want to change
> > > it.
> > 
> > Thank you for your feedback. It makes a lot of sense.
> > Changing it is not a problem :)
> > How about the updated patch below?
> > 
> Looks good.
> 
> @Mauro: Please apply.
> 

I can't seen to find this patch applied.

PING ?


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

