Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2KUP17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:27:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab2KUP16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:27:58 -0500
Date: Wed, 21 Nov 2012 16:27:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ronny Meeus <ronny.meeus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about idle time in /proc/stat
Message-ID: <20121121152756.GA8767@dhcp22.suse.cz>
References: <CAMJ=MEdyKaTFhON6aWujmzWTn8vmyoChVSOxfL5iYqQobdxVxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMJ=MEdyKaTFhON6aWujmzWTn8vmyoChVSOxfL5iYqQobdxVxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-11-12 21:15:50, Ronny Meeus wrote:
> Hello

Hi,

> I have an created an application that measures the cpuload consumed by
> the tasks within a process.
> For this I use the file /proc/stat and /proc/<pid>/tasks/<tid>/stat
> 
> The cpuload monitor is a very simple application that just executes in
> a loop a sleep command, followed by retrieving the information about
> all the tasks belonging to the process.
> What I observe is that there is a big difference in the idle time
> available in the /proc/stat file.
> 
> This is the Linux version I use:
> Linux version 2.6.36.4 (meeusr@devws156) (gcc version 4.4.3
> (crosstool-NG 1.15.2 - buildroot 2012.05-hga35945e88d23) ) #1 SMP
> PREEMPT Wed Oct 10 08:41:17 CEST 2012
> Please note that this is a kernel that contains patches of FreeScale.
[...]
> 2181820:130777 Delta=889 User=39 NiceUser=0 System=5 Idle=356
> 2181821:131720 Delta=875 User=39 NiceUser=0 System=6 Idle=356
> 2181822:132650 Delta=892 User=40 NiceUser=0 System=5 Idle=356
> 2181823:133598 Delta=874 User=38 NiceUser=0 System=6 Idle=357
> 2181824:134527 Delta=880 User=38 NiceUser=0 System=6 Idle=356
> 2181825:135460 Delta=876 User=39 NiceUser=0 System=5 Idle=356
> 2181826:136390 Delta=882 User=39 NiceUser=0 System=5 Idle=356
> 2181827:137333 Delta=909 User=40 NiceUser=0 System=9 Idle=396
> 2181828:138303 Delta=895 User=39 NiceUser=0 System=5 Idle=256
> 2181829:139255 Delta=893 User=39 NiceUser=0 System=5 Idle=256
> 2181830:140206 Delta=893 User=39 NiceUser=0 System=5 Idle=256
> 2181831:141155 Delta=891 User=38 NiceUser=0 System=6 Idle=256
> 2181832:142103 Delta=869 User=39 NiceUser=0 System=5 Idle=257
> 2181833:143051 Delta=868 User=39 NiceUser=0 System=5 Idle=256
> 2181834:143976 Delta=886 User=38 NiceUser=0 System=6 Idle=256
> 2181835:144919 Delta=890 User=39 NiceUser=0 System=5 Idle=256
> 2181836:145866 Delta=887 User=38 NiceUser=0 System=6 Idle=256
> 2181837:146814 Delta=906 User=41 NiceUser=0 System=8 Idle=1254
> 2181838:147782 Delta=891 User=38 NiceUser=0 System=6 Idle=256
> 2181839:148729 Delta=892 User=39 NiceUser=0 System=5 Idle=256
> 2181840:149678 Delta=891 User=39 NiceUser=0 System=5 Idle=256
> 2181841:150626 Delta=888 User=38 NiceUser=0 System=6 Idle=256
> 2181842:151571 Delta=889 User=39 NiceUser=0 System=5 Idle=257
> 2181843:152515 Delta=885 User=39 NiceUser=0 System=5 Idle=256
> 2181844:153457 Delta=890 User=38 NiceUser=0 System=6 Idle=256
> 2181845:154403 Delta=885 User=39 NiceUser=0 System=5 Idle=256
> 2181846:155343 Delta=886 User=39 NiceUser=0 System=5 Idle=256
> 2181847:156288 Delta=907 User=40 NiceUser=0 System=9 Idle=1253
> 2181848:157257 Delta=891 User=39 NiceUser=0 System=5 Idle=256
> 2181849:158204 Delta=888 User=39 NiceUser=0 System=6 Idle=256
> 2181850:159150 Delta=895 User=38 NiceUser=0 System=6 Idle=256
> 2181851:160102 Delta=871 User=39 NiceUser=0 System=4 Idle=257
> 2181852:161054 Delta=876 User=39 NiceUser=0 System=6 Idle=255
> 2181853:161989 Delta=883 User=39 NiceUser=0 System=5 Idle=257
> 2181854:162932 Delta=891 User=39 NiceUser=0 System=5 Idle=267
> 2181855:163878 Delta=887 User=39 NiceUser=0 System=6 Idle=245
> 2181856:164821 Delta=889 User=39 NiceUser=0 System=5 Idle=256
> 2181857:165769 Delta=910 User=40 NiceUser=0 System=9 Idle=1253
> 2181858:166740 Delta=890 User=39 NiceUser=0 System=5 Idle=256
> 2181859:167686 Delta=884 User=38 NiceUser=0 System=5 Idle=256
> 2181860:168627 Delta=888 User=39 NiceUser=0 System=6 Idle=263
> 
> 
> The first column is the timestamp returned by gettimeofday. This is
> nicely incrementing 1 second at a time.
> The Delta shows how long it took to execute the processing of the stat file.
> 
> Since this is a 4 core machine, I would expect that the sum of
> User,NiceUser,System and Idle is 400 (100 Ticks per core).
> In some samples this is correct, while in other samples, the sum is
> only something like 300 while in one of the next samples the idle time
> suddenly increases to 1253.
> So it looks like the time it has lost before is recovered in that one sample.
> 
> Can somebody explain what the issue is and how it can be resolved?

I assume you are using tickless kernel (CONFIG_NOHZ). If this is the
case then this is caused by the idle time accounting which is tick
based. This means that the per-CPU counter is not updated while the CPU
is idle. Have a look at a25cac519 (proc: Consider NO_HZ when printing
idle and iowait times) for more information. You will also need:
6beea0cd - nohz: Fix update_ts_time_stat idle accounting
09a1d34f - nohz: Make idle/iowait counter update conditional
as prerequisites and
2a95ea6c - procfs: do not overflow get_{idle,iowait}_time for nohz
34845636 - procfs: do not confuse jiffies with cputime64_t

-- 
Michal Hocko
SUSE Labs
