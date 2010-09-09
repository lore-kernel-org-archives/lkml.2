Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0IIVWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:22:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39297 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0IIVWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:22:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [patch] pm_qos_params: cleanup: terminate a string
Date: Thu, 9 Sep 2010 23:21:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Dan Carpenter <error27@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20100903124105.GJ5437@bicker> <201009090014.00158.rjw@sisk.pl> <20100909025619.GA5049@gvim.org>
In-Reply-To: <20100909025619.GA5049@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009092321.24644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 09, 2010, mark gross wrote:
> On Thu, Sep 09, 2010 at 12:13:59AM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, September 07, 2010, mark gross wrote:
> > > On Mon, Sep 06, 2010 at 11:22:27PM -0700, mark gross wrote:
> > > > On Fri, Sep 03, 2010 at 02:41:06PM +0200, Dan Carpenter wrote:
> > ...
> > > 
> > > updated patch 
> > > 
> > > Signed-off-by: mark gross <markgross@thegnar.org>
> > > 
> > > --mgross 
> > > 
> > > Subject: [PATCH] correct some pr_debug misuse and add a stronger parrameter check to
> > >  pm_qos_write for the ascii hex value case.  Thanks to Dan Carpenter for
> > >  pointing out the problem!
> > > 
> > > ---
> > >  kernel/pm_qos_params.c |    6 ++++--
> > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > > index f42d3f7..aae58d2 100644
> > > --- a/kernel/pm_qos_params.c
> > > +++ b/kernel/pm_qos_params.c
> > > @@ -155,7 +155,7 @@ static void update_target(int pm_qos_class)
> > >  		call_notifier = 1;
> > >  		atomic_set(&pm_qos_array[pm_qos_class]->target_value,
> > >  				extreme_value);
> > > -		pr_debug(KERN_ERR "new target for qos %d is %d\n", pm_qos_class,
> > > +		pr_debug("new target for qos %d is %d\n", pm_qos_class,
> > >  			atomic_read(&pm_qos_array[pm_qos_class]->target_value));
> > >  	}
> > >  	spin_unlock_irqrestore(&pm_qos_lock, flags);
> > 
> > The above doesn't apply to the Linus' tree any more.  Care to fix?
> > 
> > Rafael
> 
> no problem.  (I screwed up on my fetch and forgot to merge the linus
> remote....) This bit doesn't apply post 2.6.35.
> --mgross

Thanks, applied to suspend-2.6/linux-next .

Rafael


> Signed-off-by: mark gross <markgross@thegnar.org)
> 
> 
> From 64753f68e2baaef21783192566469abc54aca90d Mon Sep 17 00:00:00 2001
> From: mgross <mgross@mgross-laptop.(none)>
> Date: Wed, 8 Sep 2010 19:52:39 -0700
> Subject: [PATCH] make it harder to misuse the pm_qos user mode api.
> 
> ---
>  kernel/pm_qos_params.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index b7e4c36..645e541 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -389,10 +389,12 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  	} else if (count == 11) { /* len('0x12345678/0') */
>  		if (copy_from_user(ascii_value, buf, 11))
>  			return -EFAULT;
> +		if (strlen(ascii_value) != 10)
> +			return -EINVAL;
>  		x = sscanf(ascii_value, "%x", &value);
>  		if (x != 1)
>  			return -EINVAL;
> -		pr_debug(KERN_ERR "%s, %d, 0x%x\n", ascii_value, x, value);
> +		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
>  	} else
>  		return -EINVAL;
>  
> 

