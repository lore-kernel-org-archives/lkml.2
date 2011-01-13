Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1AMWwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:52:51 -0500
Received: from www.tglx.de ([62.245.132.106]:47699 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1AMWwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:52:44 -0500
Date: Thu, 13 Jan 2011 23:52:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
In-Reply-To: <20110113224450.GA14918@kroah.com>
Message-ID: <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
References: <20110111010714.GB32585@kroah.com> <4D2BB048.2050509@kernel.org> <1294723290.17779.349.camel@pasglop> <4D2BF9F3.5080709@kernel.org> <1294731467.17779.352.camel@pasglop> <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
 <20110111135655.GA6901@kroah.com> <4D2CFEAD.6070206@kernel.org> <1294799565.9586.13.camel@pasglop> <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Greg KH wrote:
> On Thu, Jan 13, 2011 at 02:21:29PM -0800, Yinghai Lu wrote:
> > +extern void use_normal_delay(void);
> > +extern void use_normal_sleep(void);
> >  #endif /* defined(_LINUX_DELAY_H) */
> > Index: linux-2.6/init/main.c
> > ===================================================================
> > --- linux-2.6.orig/init/main.c
> > +++ linux-2.6/init/main.c
> > @@ -879,6 +879,9 @@ static int __init kernel_init(void * unu
> >  	cad_pid = task_pid(current);
> >  
> >  	smp_prepare_cpus(setup_max_cpus);
> > +	/* set them back, x86 use it for early delay*/
> > +	use_normal_delay();
> > +	use_normal_sleep();
> 
> Ick, I really don't like this.
> 
> And, most importantly, I'm still not sure it's needed at all, as I don't
> agree with your previous patches that you say this one is needed for.
> 
> So, how about we work on the original root problem here before worrying
> about changing the main usleep logic for the whole kernel?

What the hell is the root problem ?

Thanks,

	tglx
