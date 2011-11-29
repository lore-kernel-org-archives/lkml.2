Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1K2NKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:10:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1K2NKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:10:44 -0500
Date: Tue, 29 Nov 2011 14:10:42 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Subject: Re: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111129131042.GC4043@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
 <20111129123156.GA4043@tiehlicka.suse.cz>
 <20111129124406.GB4043@tiehlicka.suse.cz>
 <1833322904.224056.1322571256185.JavaMail.mail@webmail07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1833322904.224056.1322571256185.JavaMail.mail@webmail07>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-11-11 12:54:16, Artem S. Tashkinov wrote:
> > On Nov 29, 2011, Michal Hocko  wrote: 
> > 
> > On Tue 29-11-11 13:31:56, Michal Hocko wrote:
> > > On Tue 29-11-11 11:38:47, Artem S. Tashkinov wrote:
> > [...]
> > > > $ grep . -r /sys/devices/system/cpu/cpuidle/
> > > > /sys/devices/system/cpu/cpuidle/current_driver:intel_idle
> > > > /sys/devices/system/cpu/cpuidle/current_governor_ro:menu
> > 
> > Could you try with acpi_idle driver?
> > echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
> 
> [root@localhost ~]# echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
> -bash: /sys/devices/system/cpu/cpuidle/current_driver: Permission denied

It seems that this is cannot be set in runtime:
SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);

Or maybe you need to boot with cpuidle_sysfs_switch. According to the
documentation you might be able to change the governor. I have no idea
whether this can help somehow but let's try that.

I haven't found any intel_idle machine in my lab so far and all other
acpi_idle machines seem to work (or at least randomly selected ones) so
this smells like a major difference in the setup.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
