Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1K2Mb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:31:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab1K2Mb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:31:58 -0500
Date: Tue, 29 Nov 2011 13:31:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Subject: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111129123156.GA4043@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-11-11 11:38:47, Artem S. Tashkinov wrote:
> On Nov 29, 2011, Michal Hocko <mhocko@suse.cz> wrote: 
>  
> > As I have written in other email could you post your config and collect
> > the following data?
> > for i in `seq 30`; 
> > do 
> >         cat /proc/stat > `date +'%s'`
> >         sleep 1
> > done
> > export old_user=0 old_nice=0 old_sys=0 old_idle=0 old_iowait=0; 
> > 
> > # for all your available CPUs
> > grep cpu0 * | while read cpu user nice sys idle iowait rest; 
> > do 
> >         echo $cpu $(($user-$old_user)) $(($nice-$old_nice)) $(($sys-$old_sys)) $(($idle-$old_idle)) $(($iowait-$old_iowait))
> >         old_user=$user old_nice=$nice old_sys=$sys old_idle=$idle old_iowait=$iowait
> > done
> 
> 1322566208:cpu0 5199 0 2931 357890604 2541
> 1322566209:cpu0 0 0 1 0 0
> 1322566210:cpu0 0 0 0 0 0
> 1322566211:cpu0 0 0 0 0 0
> 1322566212:cpu0 0 0 0 0 0
> 1322566213:cpu0 0 0 0 0 0
> 1322566214:cpu0 1 0 0 0 0
> 1322566215:cpu0 2 0 0 0 0
> 1322566216:cpu0 3 0 0 0 0
> 1322566217:cpu0 2 0 0 0 0
> 1322566218:cpu0 4 0 0 0 0
> 1322566219:cpu0 1 0 0 0 0
> 1322566220:cpu0 2 0 0 0 0
> 1322566221:cpu0 2 0 1 0 0
> 1322566222:cpu0 1 0 0 0 0
> 1322566223:cpu0 2 0 0 0 0
> 1322566224:cpu0 1 0 1 0 0
> 1322566225:cpu0 1 0 0 0 0
> 1322566226:cpu0 2 0 0 0 0
> 1322566227:cpu0 1 0 1 0 0
> 1322566228:cpu0 2 0 0 0 0
> 1322566229:cpu0 2 0 0 0 0
> 1322566230:cpu0 6 0 3 0 0
> 1322566231:cpu0 1 0 0 0 0
> 1322566232:cpu0 2 0 0 0 0
> 1322566233:cpu0 3 0 0 0 0
> 1322566234:cpu0 2 0 0 0 0
> 1322566235:cpu0 2 0 2 0 0
> 1322566236:cpu0 0 0 1 0 0
> 1322566237:cpu0 1 0 0 0 0

Hmm, really strange. It looks that idle/iowait is not accounted at
all. Which would explain why the numbers you are seeing are so weird.


> 
> $ grep . -r /sys/devices/system/cpu/cpuidle/
> /sys/devices/system/cpu/cpuidle/current_driver:intel_idle
> /sys/devices/system/cpu/cpuidle/current_governor_ro:menu

I will check whether I have a machine with intel_idle somewhere around.

> 
> $ grep . -r /sys/devices/system/cpu/cpufreq/
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_min:10000
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate:10000
> /sys/devices/system/cpu/cpufreq/ondemand/up_threshold:95
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor:1
> /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load:0
> /sys/devices/system/cpu/cpufreq/ondemand/powersave_bias:0
> /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy:1
> 
> One thing I have to note, it takes some time (from 30 seconds to 10
> minutes) before this bug starts manifesting itself.




-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
