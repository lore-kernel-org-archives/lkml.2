Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1ANTIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:08:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab1ANTIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:08:01 -0500
Date: Fri, 14 Jan 2011 11:04:58 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@suse.de>
Subject: Re: [PATCH] tty/tty_io.c: fix compilation warning
Message-ID: <20110114190458.GC14124@suse.de>
References: <1294989497-2531-1-git-send-email-viresh.kumar@st.com>
 <4D301239.5030303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D301239.5030303@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 10:07:05AM +0100, Jiri Slaby wrote:
> On 01/14/2011 08:18 AM, Viresh Kumar wrote:
> > This patch fixes following compilation warning:
> > tty/tty_io.c:3309: warning: ignoring return value of 'device_create_file',
> > declared with attribute warn_unused_result
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> > ---
> >  drivers/tty/tty_io.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> > index 464d09d..b558f03 100644
> > --- a/drivers/tty/tty_io.c
> > +++ b/drivers/tty/tty_io.c
> > @@ -3291,6 +3291,8 @@ void console_sysfs_notify(void)
> >   */
> >  int __init tty_init(void)
> >  {
> > +	int ret = 0;
> > +
> >  	cdev_init(&tty_cdev, &tty_fops);
> >  	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
> >  	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
> > @@ -3306,11 +3308,11 @@ int __init tty_init(void)
> >  	if (IS_ERR(consdev))
> >  		consdev = NULL;
> >  	else
> > -		device_create_file(consdev, &dev_attr_active);
> > +		ret = device_create_file(consdev, &dev_attr_active);
> >  
> >  #ifdef CONFIG_VT
> >  	vty_init(&console_fops);
> >  #endif
> > -	return 0;
> > +	return ret;
> 
> NACK
> 
> There is no failpath handling. And I think Kay has a patch for that
> already where he ignores the retval.

Yes, it's in my "to-apply" queue that I will get to when I return to
civilization next Wednesday.

thanks,

greg k-h
