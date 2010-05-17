Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0EQLck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:32:40 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:55356 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754360Ab0EQLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:32:39 -0400
Date: Mon, 17 May 2010 07:31:42 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jeff Dike <jdike@addtoit.com>
Message-ID: <1333713281.977451274095902288.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20100516223054.GA5276@nowhere>
Subject: Re: [PATCH] uml: Convert to unlocked_ioctls to remove implicit BKL
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Frederic Weisbecker" <fweisbec@gmail.com> wrote:

> On Fri, May 07, 2010 at 05:34:28PM +0200, John Kacur wrote:
> > Convert to hostaudio_ioctl and hostmixer_ioctl_mixdev to
> unlocked_ioctl
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> 
> 
> 
> Hi John,
> 
> The patch looks good and I'm about to queue it, however it lacks
> a changelog that properly explains the safety of the conversion.
> 
> Are you fine with this?
> 
> "We don't do anything except relying the ioctl to the host which

s/relying/relaying

Other than that, fine with me, thanks!
John

> should then take care of the synchronization."
> 
> Thanks.
> 
> 
> 
> 
> >  arch/um/drivers/hostaudio_kern.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/um/drivers/hostaudio_kern.c
> b/arch/um/drivers/hostaudio_kern.c
> > index 368219c..ae42695 100644
> > --- a/arch/um/drivers/hostaudio_kern.c
> > +++ b/arch/um/drivers/hostaudio_kern.c
> > @@ -136,7 +136,7 @@ static unsigned int hostaudio_poll(struct file
> *file,
> >  	return mask;
> >  }
> >  
> > -static int hostaudio_ioctl(struct inode *inode, struct file *file,
> > +static long hostaudio_ioctl(struct file *file,
> >  			   unsigned int cmd, unsigned long arg)
> >  {
> >  	struct hostaudio_state *state = file->private_data;
> > @@ -223,7 +223,7 @@ static int hostaudio_release(struct inode
> *inode, struct file *file)
> >  
> >  /* /dev/mixer file operations */
> >  
> > -static int hostmixer_ioctl_mixdev(struct inode *inode, struct file
> *file,
> > +static long hostmixer_ioctl_mixdev(struct file *file,
> >  				  unsigned int cmd, unsigned long arg)
> >  {
> >  	struct hostmixer_state *state = file->private_data;
> > @@ -289,7 +289,7 @@ static const struct file_operations
> hostaudio_fops = {
> >  	.read           = hostaudio_read,
> >  	.write          = hostaudio_write,
> >  	.poll           = hostaudio_poll,
> > -	.ioctl          = hostaudio_ioctl,
> > +	.unlocked_ioctl	= hostaudio_ioctl,
> >  	.mmap           = NULL,
> >  	.open           = hostaudio_open,
> >  	.release        = hostaudio_release,
> > @@ -298,7 +298,7 @@ static const struct file_operations
> hostaudio_fops = {
> >  static const struct file_operations hostmixer_fops = {
> >  	.owner          = THIS_MODULE,
> >  	.llseek         = no_llseek,
> > -	.ioctl          = hostmixer_ioctl_mixdev,
> > +	.unlocked_ioctl	= hostmixer_ioctl_mixdev,
> >  	.open           = hostmixer_open_mixdev,
> >  	.release        = hostmixer_release,
> >  };
> > -- 
> > 1.6.6.1
> >
