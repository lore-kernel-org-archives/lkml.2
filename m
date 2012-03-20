Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2CTJr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:47:29 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57506 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab2CTJr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+pWcCZ28ByXuOu72FAAAQAPny3O0WDvd+vv1TryXw+9DMKwiA@mail.gmail.com>
References: <CA+pWcCZ28ByXuOu72FAAAQAPny3O0WDvd+vv1TryXw+9DMKwiA@mail.gmail.com>
From: Nicolas Maupu <nmaupu@excilys.com>
Date: Tue, 20 Mar 2012 10:47:07 +0100
Message-ID: <CAFO9wVJVCm0BB-cs1JeADf6pC4y=GtYsg5ZW+iBcV+heB7QvHA@mail.gmail.com>
Subject: Re: extreme system load [kswapd]
To: =?UTF-8?Q?Karol_=C5=A0ebesta?= <sebesta.karol@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-admin@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Maybe, try to track IO on your machine (iostat) to see if it is an IO
problem (i.e. write to disk) or not.


On Tue, Mar 20, 2012 at 10:08, Karol Šebesta <sebesta.karol@gmail.com> wrote:
>
> Hello @All,
>
> We have a problem on our production machine with high CPU utilization
> caused by kswapd3 daemon. Server is 128GB of physical memory and 81GB
> of SWAP.
>
>
> # cat /etc/redhat-release
> Red Hat Enterprise Linux Server release 5.6 (Tikanga)
> #
>
>
> # uptime
>  09:52:13 up 38 days, 17:01, 14 users,  load average: 43.93, 50.02, 51.36
> #
>
>
> # free -m
>             total       used       free     shared    buffers     cached
> Mem:        128989      75577      53412          0        416      57131
> -/+ buffers/cache:      18029     110960
> Swap:        81919      31310      50609
> #
>
> ### from TOP:
>
> Tasks: 1590 total,   3 running, 1578 sleeping,   1 stopped,   8 zombie
> Cpu(s):  1.1%us,  1.9%sy,  0.0%ni, 74.4%id, 22.4%wa,  0.0%hi,  0.2%si,  0.0%st
> Mem:  132085528k total, 77397544k used, 54687984k free,   426472k buffers
> Swap: 83886064k total, 32043168k used, 51842896k free, 58475692k cached
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  1816 root      10  -5     0    0    0 D 203.0  0.0   1124:39 kswapd3
> 10801 root      15   0  113m  23m 1680 S 158.6  0.0   1694:13 vxconfigd
>  3925 root      RT   0  162m  15m 3368 S 140.1  0.0   1313:32 multipathd
> 21399 wsy5067   16   0 22768 3192 1704 S 50.3  0.0   0:12.96 top
> 10583 root      15   0     0    0    0 S 43.8  0.0  58:56.55 dmp_daemon
> 16673 root      16   0 17720 1220  792 S 37.3  0.0 732:23.49 cmafcad
> 24636 oracle    15   0 3314m  41m  40m S 26.6  0.0  29:31.84 oracle
>  487 oracle    15   0 3301m  90m  88m S 21.4  0.1   1:05.68 oracle
> 14197 root      18   0  315m  15m 3984 S 21.1  0.0 346:15.70 vxsvc
> 26071 root      15   0 23900 6788 2092 S 19.8  0.0  12:31.44 MountAgent
> 16418 root      15   0  5308 3656  592 S 19.1  0.0 544:54.78 cmahostd
>  485 oracle    15   0 3301m  87m  87m S 18.8  0.1   1:03.92 oracle
> 21456 root      15   0     0    0    0 S 18.5  0.0  14:16.09 pdflush
>  4699 root      22   0 65204 8420 1568 S 15.6  0.0 137:15.75 vxdclid
> 16603 root      18   0  8820 6808  332 D 14.3  0.0   1290:32 cmaperfd
> 22047 tlmcron1  18   0 1227m 115m 6812 S 12.3  0.1 554:55.86 java
>  6157 oracle    16   0 3302m 118m 115m D 11.4  0.1   0:01.29 oracle
> 30669 oracle    16   0 2066m 141m 134m D 10.7  0.1   0:20.19 oracle
>  357 tlmtst3   18   0  101m  15m 9292 S  9.7  0.0   0:29.43 stlfetch
> 15005 oracle    16   0 2046m  84m  75m D  9.7  0.1   0:01.75 oracle
> 32744 tlmtst3   18   0  101m  15m 9292 S  8.8  0.0   0:31.52 stlfetch
> 26077 root      15   0 12116 4228 1936 S  7.8  0.0   4:26.71 VolumeAgent
> 17955 oracle    16   0 3301m  28m  25m D  7.1  0.0   0:00.22 oracle
> 26076 root      15   0 23268 5284 2224 S  6.8  0.0   4:00.50 OracleAgent
>  111 root      10  -5     0    0    0 S  6.5  0.0   4:57.32 events/13
>  5112 oracle    16   0 3314m  35m  35m S  6.5  0.0  10:38.55 oracle
> 10440 oracle    16   0 3314m  36m  36m S  6.5  0.0  10:54.65 oracle
> 26074 root      15   0 23012 4904 2136 S  6.5  0.0   3:09.46 NetlsnrAgent
>  8631 oracle    16   0 3315m  37m  36m S  6.2  0.0  12:04.57 oracle
> 26636 oracle    15   0 3316m  40m  39m S  6.2  0.0  13:07.75 oracle
> 10780 oracle    16   0 6386m  39m  39m D  5.8  0.0  10:57.01 oracle
> 13091 tlmtst5   15   0  423m  18m  13m S  5.8  0.0   0:02.76 gedit
> 17212 oracle    15   0 2050m  39m  39m S  5.8  0.0  11:30.82 oracle
> 20283 oracle    15   0 3314m  41m  40m S  5.8  0.0  10:49.00 oracle
> 13147 oracle    15   0 3314m  43m  43m S  5.5  0.0  10:43.12 oracle
> 16875 oracle    15   0 3316m  42m  40m S  5.5  0.0  22:52.66 oracle
> 28143 root      15   0  111m 6700 3396 S  5.5  0.0 143:25.46 opcmona
>  5718 oracle    16   0 3314m  38m  36m S  5.2  0.0  11:30.95 oracle
> 22163 oracle    15   0 3316m  39m  38m S  5.2  0.0  32:51.94 oracle
> 26065 root      15   0 22960 4724 2164 S  4.5  0.0   1:53.23 ApplicationAgen
> 26612 oracle    18   0 3302m  22m  19m S  4.2  0.0  23:31.48 oracle
>  8597 oracle    18   0 3302m  18m  16m S  3.9  0.0  23:30.62 oracle
> 10690 oracle    18   0 6373m  20m  16m S  3.9  0.0  23:28.74 oracle
> 11822 oracle    18   0 2038m  29m  25m S  3.9  0.0   0:05.17 oracle
>
> Why the kswapd daemon causing so high CPU utilization? Can it be
> caused by some process which try to access memory pages which are not
> in memory, but in swap? Or can it be cause by swapping for exapmple
> some inactive oracle database SGA from memory to swap?
>
> Thank you for help.
>
>
> Regards,
>
> Karol Sebesta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-admin" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--

Nicolas Maupu - SS2J - Excilys
Tél :+33 (0) 1 41 24 43 27
