Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1K2VQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:16:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38772 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab1K2VQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:16:54 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage metering applications has gone crackers
Date: Tue, 29 Nov 2011 22:16:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.3; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
In-Reply-To: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111292216.48928.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 24 listopada 2011 o 11:30:15 Artem S. Tashkinov wrote:
> Hello,
> 
> I'd like to report a weird regression in Linux 3.2 (running rc3 now) - all
> CPU metering applications have gone terribly mad under this kernel:
> 
> Here are two text snapshots of htop:
> 
>   1  [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]
>     Tasks: 135 total, 1 running 2 
> [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]    
> Load average: 0.00 0.01 0.05 3 
> [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]    
> Uptime: 00:27:49 4 
> [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]    
> Load: 0.00 Mem[||||||||||||                                             
> 544/8093MB]    
> Avg[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]
> 
>  IORR  IOWR    IO   PID USER     PRI  NI  VIRT   RES   SHR S CPU% MEM%  
> TIME+  Command 0     0     0  3529 root      20   0 70052 52244 19324 S
> 300.  0.6  0:25.93 /usr/bin/X -br 0     0     0  3678 user      20   0
> 33952 10220  8448 S 100.  0.1  0:03.58 gkrellm 0     0     0  3772 user   
>   20   0 32144 13960  9532 S 100.  0.2  0:07.46 konsole [kdeinit] --noxft
> 0     0     0  6061 user      20   0  2780  1276   960 R 100.  0.0 
> 0:00.01 htop 0     0     0     1 root      20   0  2884  1376  1168 S  0.0
>  0.0  0:01.00 /sbin/init 0     0     0     2 root      20   0     0     0 
>    0 S  0.0  0.0  0:00.00 kthreadd
> 
> 
>   1  [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]
>     Tasks: 135 total, 1 running 2 
> [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]    
> Load average: 0.00 0.01 0.05 3 
> [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]    
> Uptime: 00:28:43 4 
> [||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]    
> Load: 0.00 Mem[||||||||||||                                             
> 545/8093MB]    
> Avg[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||100.0%]
> 
>  IORR  IOWR    IO   PID USER     PRI  NI  VIRT   RES   SHR S CPU% MEM%  
> TIME+  Command 0     0     0  6061 user      20   0  2780  1288   972 R
> 57.0  0.0  0:00.11 htop 0     0     0  5243 user      20   0  559M  318M
> 30928 S 57.0  3.9  0:26.07 /opt/firefox/firefox 0     0     0  3687 user  
>    20   0  108M 39124 23564 S 57.0  0.5  0:06.50 kedit 0     0     0  3637
> user      20   0 26960  5572  4288 S 57.0  0.1  0:00.02 klauncher
> [kdeinit] --new-startup 0     0     0  3529 root      20   0 70052 52244
> 19324 S  0.0  0.6  0:26.71 /usr/bin/X -br
> 
> Interestingly with this madness going on, the internal kernel average load
> counter works properly:
> 
> [root@localhost ~]# uptime
>  16:20:38 up 44 min,  2 users,  load average: 0.02, 0.04, 0.05
> 
> Right at this moment all process viewers report 400% CPU load (I have 4 CPU
> cores), either 400% loaded by user processes or 200% by system and 200% by
> user processes.
> 
> Graphically it looks this way:
> http://img717.imageshack.us/img717/6495/top2b.png
> 
> I'm not running any CPU intensive applications at the moment at all.
> 
> My .config file can be downloaded here: http://ompldr.org/iYmZneg
> 
> My distro is Fedora 14 i686.
> 
> Best wishes,
> 
> Artem
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Seems be similar to:
http://marc.info/?l=linux-kernel&m=132156832124314&w=2
http://marc.info/?l=linux-kernel&m=132164909313594&w=2

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
