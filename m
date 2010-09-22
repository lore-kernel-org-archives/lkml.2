Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab0IVK1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:27:45 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40764 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab0IVK1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:27:44 -0400
Date: Wed, 22 Sep 2010 12:27:42 +0200
From: Florian Mickler <florian@mickler.org>
To: Karsten Mehrhoff <kawime@gmx.de>
Newsgroups: gmane.linux.kernel,gmane.comp.video.dri.devel
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, stable@kernel.org
Subject: Re: [stable] regression in 2.6.35.4 'load is to heavy (video
 subsystem?)'
Message-ID: <20100922122742.69dd1b8c@schatten.dmk.lab>
In-Reply-To: <op.vjfg9fo2gp7xae@127.0.0.1>
References: <op.vh8rams6gp7xae@127.0.0.1>
	<20100921165007.6200846f.akpm@linux-foundation.org>
	<20100922000101.GA5077@kroah.com>
	<op.vjfg9fo2gp7xae@127.0.0.1>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 11:42:41 +0200
Karsten Mehrhoff <kawime@gmx.de> wrote:

> [Am 22.09.2010, 02:01 Uhr, schrieb Greg KH <greg@kroah.com>]
> 

> >>> Difference between 2.6.35.1/2/3 and 2.6.35.4 while watching some  
> >> videos:
> >>> 2.6.35.4 switches the cpu for flash videos in the browser (opera or
> >>> iceweasel) or other video outputs to 2200/2400/2600 MHz meanwhile  
> >> 2.6.35.3
> >>> (or older) stays at 1000 Mhz. That results in a higher cpu  
> >> temperature,
> >>> more power consumption and so one.
> >>>
> >>> Using other GUI program results in nearly the same problems with  
> >> 2.6.35.4,
> >>> so this kernel is unusable for me.
> >>>
> >>> Results to see the difference for the same action
> >>> 2.6.35.4
> >>> Core0 Temp:  +45.0__C
> >>> Core1 Temp:  +43.0__C
> >>> cpu MHz:	2200.000 or higher
> >>>
> >>> 2.6.35.3
> >>> Core0 Temp:  +32.0__C
> >>> Core1 Temp:  +31.0__C
> >>> cpu MHz:	1000.000 (max. 1800, but falling back to 1000)
> >
> > Can you run 'git bisect' between 2.6.35.3 and 2.6.35.4 to try to find
> > out the offending patch that caused this issue?
> >
> > thanks,
> >
> > greg k-h
> 
> Same for 2.6.35.5 using 256.53
> 
> For your info, I did run some tests today using a nVidia 9500GT
> 
>     Kernel       |   Performance with NVIDIA-Linux-x86_64-
>                  |       256.53      |    260.19.04 (BETA)
> ----------------------------------------------------------
>   2.6.35.3       |      good         |      good
> ----------------------------------------------------------
>   2.6.35.4       |       bad         |     not tested
> ----------------------------------------------------------

What would be tremendously more interesting is if you can
reproduce the issue with the in-kernel nouveau driver or just without
the binary driver. As we have no sourcecode for the binary driver, we
can not tell what it does and are thus unable to debug any issues.

If it is an issue that is not reproducible without the binary driver,
please contact the vendor of that driver. 

It it is reproducible even without that driver, it would help if you
could tell exactly which patch in 2.6.35.4 makes the difference
between good and bad in your test below.

There are 114 patches between 2.6.35.3 and 2.6.35.4. If you test
between them, you can pinpoint the exact patch with about 7 tests. 

git bisect does this for you, just do 

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
$ cd linux-2.6.35.y 
$ git bisect bad v2.6.35.4
$ git bisect good v2.6.35.3

Git then checks out a testcandidate for you, which you should compile
and test. If it's good , type 
$ git bisect good
, if its bad
$ git bisect bad

If all goes well, after about 7 tests, it will tell you
what patch did introduce the regression.

Regards,
Flo
 
> 
> Karsten
