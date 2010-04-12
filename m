Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0DLILE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:11:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab0DLILB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:11:01 -0400
Date: Mon, 12 Apr 2010 10:11:00 +0200
From: Jan Blunck <jblunck@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 04/12] frv: remove "struct file *" argument from sysctl ->proc_handler
Message-ID: <20100412081100.GZ10776@bolzano.suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de> <1270821655-4368-5-git-send-email-jblunck@suse.de> <u2xb6fcc0a1004090923h261c099fpc40b3c289e981b28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <u2xb6fcc0a1004090923h261c099fpc40b3c289e981b28@mail.gmail.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, Alexey Dobriyan wrote:

> On Fri, Apr 9, 2010 at 5:00 PM, Jan Blunck <jblunck@suse.de> wrote:
> > Seems that Alexey Dobriyan missed this usage of the file argument when
> > removing it from ->proc_handler in commit 8d65af789f3e2cf4cfbdbf71a0f7a61ebcd41d38.
> 
> It wasn't missed, it was deliberately left out because I didn't understand
> what's going on there.
> 
> I mean, sysctl handler touching ->f_pos, come on!
> 
> What's going on?
> 

It is just a normal /proc/sys file. You can write a string to it to change the
some caching mode somehow.

Jan

> > --- a/arch/frv/kernel/sysctl.c
> > +++ b/arch/frv/kernel/sysctl.c
> > @@ -85,7 +86,7 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
> >        }
> >
> >        /* read the state */
> > -       if (filp->f_pos > 0) {
> > +       if (*ppos > 0) {
> >                *lenp = 0;
> >                return 0;
> >        }
Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
