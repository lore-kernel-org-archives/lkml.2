Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1AMXDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:03:24 -0500
Received: from kroah.org ([198.145.64.141]:40489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1AMXDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:03:18 -0500
Date: Thu, 13 Jan 2011 15:02:48 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
Message-ID: <20110113230248.GA15441@kroah.com>
References: <1294723290.17779.349.camel@pasglop>
 <4D2BF9F3.5080709@kernel.org>
 <1294731467.17779.352.camel@pasglop>
 <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
 <20110111135655.GA6901@kroah.com>
 <4D2CFEAD.6070206@kernel.org>
 <1294799565.9586.13.camel@pasglop>
 <4D2F7AE9.2000809@kernel.org>
 <20110113224450.GA14918@kroah.com>
 <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:52:17PM +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Greg KH wrote:
> > On Thu, Jan 13, 2011 at 02:21:29PM -0800, Yinghai Lu wrote:
> > > +extern void use_normal_delay(void);
> > > +extern void use_normal_sleep(void);
> > >  #endif /* defined(_LINUX_DELAY_H) */
> > > Index: linux-2.6/init/main.c
> > > ===================================================================
> > > --- linux-2.6.orig/init/main.c
> > > +++ linux-2.6/init/main.c
> > > @@ -879,6 +879,9 @@ static int __init kernel_init(void * unu
> > >  	cad_pid = task_pid(current);
> > >  
> > >  	smp_prepare_cpus(setup_max_cpus);
> > > +	/* set them back, x86 use it for early delay*/
> > > +	use_normal_delay();
> > > +	use_normal_sleep();
> > 
> > Ick, I really don't like this.
> > 
> > And, most importantly, I'm still not sure it's needed at all, as I don't
> > agree with your previous patches that you say this one is needed for.
> > 
> > So, how about we work on the original root problem here before worrying
> > about changing the main usleep logic for the whole kernel?
> 
> What the hell is the root problem ?

I have yet to figure that out, even after reading the patches provided
:(

confused,

greg k-h
