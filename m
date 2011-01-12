Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1ALPf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:35:57 -0500
Received: from kroah.org ([198.145.64.141]:40117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1ALPfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:35:53 -0500
Date: Tue, 11 Jan 2011 21:07:59 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
Message-ID: <20110112050759.GA18279@kroah.com>
References: <4D2BAA75.60001@kernel.org>
 <20110111010714.GB32585@kroah.com>
 <4D2BB048.2050509@kernel.org>
 <1294723290.17779.349.camel@pasglop>
 <4D2BF9F3.5080709@kernel.org>
 <1294731467.17779.352.camel@pasglop>
 <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
 <20110111135655.GA6901@kroah.com>
 <4D2CFEAD.6070206@kernel.org>
 <1294799565.9586.13.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294799565.9586.13.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 01:32:45PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2011-01-11 at 17:06 -0800, Yinghai Lu wrote:
> > We need to use those function in early-quirk stage with code that is shared with
> > later stage.
> > 
> > for x86, normal udelay() will need to wait per_cpu(cpu_info) is allocated... that i
> > after smp_prepare_cpus(), because it need to use percpu.loops_per_jiffy.
> > 
> > Also msleep() will need to wait schedular is ready.
> > 
> > Try to have one early version udelay that use loops_per_jiffy directly.
> > and early msleep is just early delay.
> > 
> > This patch will set safe_udelay to early in x86 early arch code, and then init/main.c
> > will set them back.
> 
> I still think it's better to just make msleep() work with and without
> scheduler and avoid having to bother with a new API

I agree, this patch just makes things really complicated for no reason.

Again, I still fail to see why you are doing this patch series in the
first place...

thanks,

greg k-h
