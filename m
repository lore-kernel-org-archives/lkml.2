Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1K2Hwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:52:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1K2Hwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:52:45 -0500
Date: Tue, 29 Nov 2011 08:52:42 +0100
From: Michal Hocko <mhocko@suse.cz>
To: pomac@vapor.com
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, tino.keitel@tikei.de,
        t.artem@lycos.com
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111129075242.GB2675@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128222803.GA4925@pomac.netswarm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-11-11 23:28:03, pomac@vapor.com wrote:
> Hi, 
> 
> All this time i have been thinking i'm the only one - and i've been to
> loaded with work during working hours and tired when home =P
> 
> Anyways, I've neen seeing this since -rc1 on:
> Intel(R) Core(TM) i5 CPU U520  @ 1.07GHz - x86-64
> AMD Phenom(tm) II X6 1090T - x86-64
> AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ - x86-64
> Intel(R) Core(TM)2 CPU T7200  @ 2.00GHz - i686
> 
> Configs available on demand - I've been running the same config for
> quite some time though.

As I have written in other email could you post your config and collect
the following data?
for i in `seq 30`; 
do 
        cat /proc/stat > `date +'%s'`
        sleep 1
done
export old_user=0 old_nice=0 old_sys=0 old_idle=0 old_iowait=0; 

# for all your available CPUs
grep cpu0 * | while read cpu user nice sys idle iowait rest; 
do 
        echo $cpu $(($user-$old_user)) $(($nice-$old_nice)) $(($sys-$old_sys)) $(($idle-$old_idle)) $(($iowait-$old_iowait))
        old_user=$user old_nice=$nice old_sys=$sys old_idle=$idle old_iowait=$iowait
done

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
