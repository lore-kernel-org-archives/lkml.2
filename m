Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1AUW1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:27:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45817 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754839Ab1AUW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:27:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ClfNusryCedSVDwFo7lKUZ0+eh3huWkz2nrdHNs
	DDGBk3uT0dbXef
Subject: Re: 'autogroup' sched code KILLING responsiveness
From: Mike Galbraith <efault@gmx.de>
To: Michael Witten <mfwitten@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 23:27:50 +0100
Message-ID: <1295648870.23779.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 10:20 -0800, Michael Witten wrote:
> Bisecting shows that this commit:
> 
>   5091faa449ee0b7d73bc296a93bca9540fc51d0a
>   sched: Add 'autogroup' scheduling feature: automated per session task groups
>   Date:   Tue Nov 30 14:18:03 2010 +0100
> 
> is the reason that my computer has become unusable.
> 
> With that code in place, a resource-intensive activity (such as
> compiling the Linux kernel) causes my computer to become
> unresponsive for many seconds at a time; the entire screen
> does not refresh, typed keys are dropped or are handled very
> late, etc (even in Linux's plain virtual consoles).

That's not what I'm experiencing with a UP kernel...

marge:~> time perf stat -a sh -c 'true'

 Performance counter stats for 'sh -c true':

             49580 cache-misses             #      5.170 M/sec  (scaled from 37.28%)
            336112 cache-references         #     35.048 M/sec  (scaled from 78.81%)
            185857 branch-misses            #     21.019 %      (scaled from 62.83%)
            884249 branches                 #     92.204 M/sec  (scaled from 21.25%)
          12672552 instructions             #      0.553 IPC    (scaled from 58.38%)
          22896301 cycles                   #   2387.490 M/sec  (scaled from 58.38%)
               410 page-faults              #      0.043 M/sec
                 0 CPU-migrations           #      0.000 M/sec
                13 context-switches         #      0.001 M/sec
          9.590115 task-clock-msecs         #      1.005 CPUs 

        0.009540836  seconds time elapsed


real    0m0.020s
user    0m0.000s
sys     0m0.000s
marge:~>

It took 20 ms to do the above and get it to my screen while the below
was running (among others).  I've got a make -j 100 running as I write
this, and don't even notice that it's running.

Can you provide some information such as hardware description,
configuration, and perhaps measurements demonstrating the problem?

top - 22:34:38 up 33 min, 22 users,  load average: 104.07, 101.73, 78.13
Tasks: 675 total, 101 running, 574 sleeping,   0 stopped,   0 zombie
Cpu(s): 95.2%us,  4.8%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND                                                              
 6770 root      20   0  401m  79m  29m R 46.9  1.0   3:22.66 0 mplayer                                                              
 6100 root      20   0  449m  94m  18m S  2.9  1.2   1:33.82 0 Xorg                                                                 
 7486 root      20   0  374m  46m  17m S  2.9  0.6   0:54.02 0 konsole                                                              
 7752 root      20   0  104m  66m 8072 R  1.0  0.8   0:01.76 0 cc1                                                                  
 9796 root      20   0 89764  49m 8028 R  1.0  0.6   0:01.21 0 cc1                                                                  
 9928 root      20   0 98916  59m 8164 R  1.0  0.7   0:01.18 0 cc1                                                                  
10321 root      20   0 88788  49m 8116 R  1.0  0.6   0:01.06 0 cc1                                                                  
10619 root      20   0 89736  50m 8068 R  1.0  0.6   0:01.00 0 cc1                                                                  
11356 root      20   0 19764 8152 2300 S  1.0  0.1   0:00.01 0 as                                                                   
11597 root      20   0 97212  56m 7924 R  1.0  0.7   0:00.65 0 cc1                                                                  
12203 root      20   0 79332  40m 7588 R  1.0  0.5   0:00.48 0 cc1                                                                  
12209 root      20   0 80760  40m 7536 R  1.0  0.5   0:00.47 0 cc1                                                                  
12247 root      20   0 85252  46m 7752 R  1.0  0.6   0:00.46 0 cc1                                                                  
12510 root      20   0 82192  40m 5184 R  1.0  0.5   0:00.36 0 cc1                                                                  
12612 root      20   0 81172  39m 5192 R  1.0  0.5   0:00.33 0 cc1                                                                  
12615 root      20   0 81160  38m 4360 R  1.0  0.5   0:00.33 0 cc1                                                                  



