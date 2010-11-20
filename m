Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0KTVmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 16:42:36 -0500
Received: from mail.perches.com ([173.55.12.10]:1605 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab0KTVmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 16:42:36 -0500
Subject: Re: [PATCHv4 06/17] pps: convert printk/pr_* to dev_*
From: Joe Perches <joe@perches.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
In-Reply-To: <20101121003323.4bbf0199@apollo.gnet>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	 <ce13c55a2acb39be7ef5667467c765595df19835.1290087479.git.lasaine@lvk.cs.msu.su>
	 <20101120154940.GY13356@enneenne.com> <20101121003323.4bbf0199@apollo.gnet>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Nov 2010 13:42:34 -0800
Message-ID: <1290289354.31117.25.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 00:33 +0300, Alexander Gordeev wrote:
> В Sat, 20 Nov 2010 16:49:40 +0100
> Rodolfo Giometti <giometti@enneenne.com> пишет:
> > On Thu, Nov 18, 2010 at 07:00:59PM +0300, Alexander Gordeev wrote:
> > > Since we now have direct pointers to struct pps_device everywhere it's
> > > easy to use dev_* functions to print messages instead of plain printks.
> > > Where dev_* cannot be used printks are converted to pr_*.
> > > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
[]
> > > @@ -80,20 +81,20 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
> > >  
> > >  	/* Sanity checks */
> > >  	if ((info->mode & default_params) != default_params) {
> > > -		printk(KERN_ERR "pps: %s: unsupported default parameters\n",
> > > +		pr_err("pps: %s: unsupported default parameters\n",
> > >  					info->name);

Perhaps you want to remove the "pps:" prefixes?

> > > -		printk(KERN_ERR "pps: %s: echo function is not defined\n",
> > > +		pr_err("pps: %s: echo function is not defined\n",
[]
> > > -		printk(KERN_ERR "pps: %s: unspecified time format\n",
> > > +		pr_err("pps: %s: unspecified time format\n",
[]
> > > -		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
> > > +		pr_err("pps: %s: too many PPS sources in the system\n",
[]
> > > -		printk(KERN_ERR "pps: %s: unable to create char device\n",
> > > +		pr_err("%s: unable to create char device\n",

It's removed here.

> > > -	printk(KERN_ERR "pps: %s: unable to register source\n", info->name);
> > > +	pr_err("%s: unable to register source\n", info->name);

and here.


