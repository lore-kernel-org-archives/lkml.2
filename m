Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1AYBzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:55:32 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39629 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab1AYBza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:55:30 -0500
X-Sasl-enc: h6ooGZzoYw4CC03m+QvjGpoP+SS6dHMH3NWL0vAE5oLh 1295920529
Subject: Re: [PATCH] autofs4: Do not potentially dereference NULL pointer
 returned by fget() in autofs_dev_ioctl_setpipefd()
From: Ian Kent <raven@themaw.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org
In-Reply-To: <alpine.LNX.2.00.1101242102040.10252@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012182238560.17400@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1101242048590.10252@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1101242102040.10252@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 09:55:24 +0800
Message-ID: <1295920524.2749.4.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 21:03 +0100, Jesper Juhl wrote:
> On Mon, 24 Jan 2011, Jesper Juhl wrote:
> 
> > Hi Ian,
> > 
> > On Sat, 18 Dec 2010, Jesper Juhl wrote:
> > 
> > > Hi,
> > > 
> > > In fs/autofs4/dev-ioctl.c::autofs_dev_ioctl_setpipefd() we call fget(), 
> > > which may return NULL, but we do not explicitly test for that NULL return 
> > > so we may end up dereferencing a NULL pointer - bad.
> > > 
> > > When I originally submitted this patch I had chosen EBUSY as the return 
> > > value to use if this happens. Ian Kent was kind enough to explain why that 
> > > would most likely be wrong and why EBADF should most likely be used 
> > > instead. This version of the patch uses EBADF.
> > > 
> > > 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > ---
> > >  dev-ioctl.c |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> > > index eff9a41..a650d7e 100644
> > > --- a/fs/autofs4/dev-ioctl.c
> > > +++ b/fs/autofs4/dev-ioctl.c
> > > @@ -372,6 +372,10 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
> > >  		return -EBUSY;
> > >  	} else {
> > >  		struct file *pipe = fget(pipefd);
> > > +		if (!pipe) {
> > > +			err = -EBADF;
> > > +			goto out;
> > > +		}
> > >  		if (!pipe->f_op || !pipe->f_op->write) {
> > >  			err = -EPIPE;
> > >  			fput(pipe);
> > > 
> > 
> > It's been more than a month now since I submitted this updated patch 
> > adressing your feedback, but I've not seen any feedback on it.
> > Is it OK? Will you merge it? 
> > 
> Ok, I need to learn to search my mailbox better. I just saw that you did 
> indeed send a reply with an Acked-by: on december 28. 
> 
> Doesn't change the fact that I still need to find someone to actually 
> merge it...
> 

Often patches like this get merged whether I ack them or not.

Right now I'm struggling with the 2.6.38-rc changes since the merge of
vfs-scale together with the vfs-automount patches caused some breakage.

I will post it along with any other patches I end up with if it doesn't
get picked up beforehand.

Ian

