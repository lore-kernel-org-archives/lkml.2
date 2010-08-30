Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0H3ICn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 30 Aug 2010 04:02:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35085 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750760Ab0H3ICl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:02:41 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX18JV057lQgJ97ENgTvdToaubDIwP2G20hE4z/253e
	noxGrHQqxhp4dU
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Subject: regression in 2.6.35.4 'load is to heavy (video subsystem?)'
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 10:02:36 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.vh8rams6gp7xae@127.0.0.1>
User-Agent: Opera Mail/10.62 (Linux)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the same .config from 2.6.35.3 to compile 2.5.36.4 results in a  
heavy load with 2.6.35.4.

Example:

Difference between 2.6.35.1/2/3 and 2.6.35.4 while watching some videos:
2.6.35.4 switches the cpu for flash videos in the browser (opera or  
iceweasel) or other video outputs to 2200/2400/2600 MHz meanwhile 2.6.35.3  
(or older) stays at 1000 Mhz. That results in a higher cpu temperature,  
more power consumption and so one.

Using other GUI program results in nearly the same problems with 2.6.35.4,  
so this kernel is unusable for me.

Results to see the difference for the same action
2.6.35.4
Core0 Temp:  +45.0°C
Core1 Temp:  +43.0°C
cpu MHz:	2200.000 or higher

2.6.35.3
Core0 Temp:  +32.0°C
Core1 Temp:  +31.0°C
cpu MHz:	1000.000 (max. 1800, but falling back to 1000)

kernel compiled with 'CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y'
results for me in 1000, 1800, 2000, 2200, 2400, 2600 MHz.

I'm not the only one with this problem, other users experienced the same  
behavior on other systems on 386 systems, i.e. a regression for glxgears  
about 30% on slower systems. We all uses differnet AMD cpus and nNida  
graphic controllers. Same results for the nvidia-kernel from the repos or  
the nVidia driver from nvidia.com.

There must something be wrong in the video subsystem, which is causing  
this regression.

My system (overview using 2.5.35.3):
=====================
Processor:	2x AMD Athlon(tm) 64 X2 Dual Core Processor 5000+
Memory:		 4060MB

Display
Resolution:       1920x1080 pixels
OpenGL Renderer:  GeForce 9500 GT/PCI/SSE2
X11 Vendor:	      The X.Org Foundation
Version:          1.7.7

Version
Kernel:			Linux 2.6.35.3-kmt (x86_64)
Compiled:	SMP Mon Aug 23 00:58:37 CEST 2010
C Library:      GNU C Library version 2.11.2 (stable)
Default C Compiler: GNU C Compiler version 4.4.5 20100824 (prerelease)  
(Debian 4.4.4-11)
Distribution:	Debian GNU/Linux squeeze/sid

OpenGL
Vendor:        NVIDIA Corporation
Renderer:      GeForce 9500 GT/PCI/SSE2
Version:       3.3.0 NVIDIA 256.44
Direct Rendering: Yes


Regards
Karsten
--
