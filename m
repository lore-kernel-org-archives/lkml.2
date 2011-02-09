Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1BICmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 21:42:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab1BICmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 21:42:12 -0500
Date: Wed, 9 Feb 2011 03:41:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Bird <tbird20d@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management all
 the time
Message-ID: <20110209024144.GA32102@elte.hu>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201102072046.48763.rjw@sisk.pl>
 <20110207201803.GU10564@opensource.wolfsonmicro.com>
 <201102072215.59921.rjw@sisk.pl>
 <20110208122159.GA8284@elte.hu>
 <AANLkTimWnT8f=PyLgOOrZOaMx0pdv+yNtPw2T7=kO2G-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWnT8f=PyLgOOrZOaMx0pdv+yNtPw2T7=kO2G-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Bird <tbird20d@gmail.com> wrote:

> On Tue, Feb 8, 2011 at 4:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> > Rafael, could you do a defconfig-ish x86 build with and without CONFIG_PM, and 
> > post the 'size vmlinux' comparison - so that we can see the size difference? We 
> > make some things CONFIG_EXPERT configurable just to enable folks who *really* 
> > want to cut down on kernel size to configure it out.
> 
> I'm one of those people who *really* wants to cut down the kernel size. I've 
> recently worked on a product where the kernel RAM budget is ~1M.

Did that kernel have CONFIG_PM disabled?

> > Note that those usecases, even if they want a super-small kernel, might not care 
> > about PM at all while they care about size: small boot kernels in ROMs, or 
> > simple devices where CPU-idling implies deep low power mode, etc.
>
> So the vmlinux size comparisons would be needed really. If it's 5k nobody will 
> care. I care about 5K.  (But honestly, I don't actively hunt stuff less than 10K 
> in size, because there's too many of them to chase, currently).

The numbers that Frank Rowand sent show 40K+:

|
| For 2.6.38-rc4, x86_64, CONFIG_NR_CPUS=4:
|
| size vmlinux
|    text     data       bss       dec      hex  filename
|
| 6553910  3555020   9994240  20103170  132c002  vmlinux    with    CONFIG_PM
| 6512652  3553116   9994240  20060008  1321768  vmlinux    without CONFIG_PM
|
|   41258     1904         0     43162                      delta
|

Thanks,

	Ingo
