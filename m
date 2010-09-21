Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0IUX6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0IUX6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:58:07 -0400
Subject: Re: regression in 2.6.35.4 'load is to heavy (video subsystem?)'
From: Dave Airlie <airlied@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karsten Mehrhoff <kawime@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, stable@kernel.org
In-Reply-To: <20100921165007.6200846f.akpm@linux-foundation.org>
References: <op.vh8rams6gp7xae@127.0.0.1>
	 <20100921165007.6200846f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 09:57:28 +1000
Message-ID: <1285113448.15213.118.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 16:50 -0700, Andrew Morton wrote:
> On Mon, 30 Aug 2010 10:02:36 +0200
> Karsten Mehrhoff <kawime@gmx.de> wrote:
> 
> > Using the same .config from 2.6.35.3 to compile 2.5.36.4 results in a  
> > heavy load with 2.6.35.4.
> 
> A regression within -stable is rather bad.
> 
> > Example:
> > 
> > Difference between 2.6.35.1/2/3 and 2.6.35.4 while watching some videos:
> > 2.6.35.4 switches the cpu for flash videos in the browser (opera or  
> > iceweasel) or other video outputs to 2200/2400/2600 MHz meanwhile 2.6.35.3  
> > (or older) stays at 1000 Mhz. That results in a higher cpu temperature,  
> > more power consumption and so one.
> > 
> > Using other GUI program results in nearly the same problems with 2.6.35.4,  
> > so this kernel is unusable for me.
> > 
> > Results to see the difference for the same action
> > 2.6.35.4
> > Core0 Temp:  +45.0__C
> > Core1 Temp:  +43.0__C
> > cpu MHz:	2200.000 or higher
> > 
> > 2.6.35.3
> > Core0 Temp:  +32.0__C
> > Core1 Temp:  +31.0__C
> > cpu MHz:	1000.000 (max. 1800, but falling back to 1000)
> > 
> > kernel compiled with 'CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y'
> > results for me in 1000, 1800, 2000, 2200, 2400, 2600 MHz.
> > 
> > I'm not the only one with this problem, other users experienced the same  
> > behavior on other systems on 386 systems, i.e. a regression for glxgears  
> > about 30% on slower systems. We all uses differnet AMD cpus and nNida  
> > graphic controllers. Same results for the nvidia-kernel from the repos or  
> > the nVidia driver from nvidia.com.
> > 
> > There must something be wrong in the video subsystem, which is causing  
> > this regression.
> > 
> > My system (overview using 2.5.35.3):
> > =====================
> > Processor:	2x AMD Athlon(tm) 64 X2 Dual Core Processor 5000+
> > Memory:		 4060MB
> > 
> > Display
> > Resolution:       1920x1080 pixels
> > OpenGL Renderer:  GeForce 9500 GT/PCI/SSE2
> > X11 Vendor:	      The X.Org Foundation
> > Version:          1.7.7
> > 
> > Version
> > Kernel:			Linux 2.6.35.3-kmt (x86_64)
> > Compiled:	SMP Mon Aug 23 00:58:37 CEST 2010
> > C Library:      GNU C Library version 2.11.2 (stable)
> > Default C Compiler: GNU C Compiler version 4.4.5 20100824 (prerelease)  
> > (Debian 4.4.4-11)
> > Distribution:	Debian GNU/Linux squeeze/sid
> > 
> > OpenGL
> > Vendor:        NVIDIA Corporation
> > Renderer:      GeForce 9500 GT/PCI/SSE2
> > Version:       3.3.0 NVIDIA 256.44
> > Direct Rendering: Yes
> 
> I'm not seeing any relevant cpufreq changes in 2.6.35.3 -> 2.6.35.4
> (ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.35.4).  There
> were a lot of DRM changes.

No us, he's using a binary driver.

Dave.

