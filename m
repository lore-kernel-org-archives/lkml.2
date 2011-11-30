Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab1K3KMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:12:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1K3KM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:12:29 -0500
Date: Wed, 30 Nov 2011 11:12:27 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, pomac@vapor.com,
        linux-kernel@vger.kernel.org, tino.keitel@tikei.de
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111130101227.GA3187@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <1833322904.224056.1322571256185.JavaMail.mail@webmail07>
 <20111129131042.GC4043@tiehlicka.suse.cz>
 <201111292351.16233.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111292351.16233.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-11-11 23:51:16, Rafael J. Wysocki wrote:
> On Tuesday, November 29, 2011, Michal Hocko wrote:
> > On Tue 29-11-11 12:54:16, Artem S. Tashkinov wrote:
> > > > On Nov 29, 2011, Michal Hocko  wrote: 
> > > > 
> > > > On Tue 29-11-11 13:31:56, Michal Hocko wrote:
> > > > > On Tue 29-11-11 11:38:47, Artem S. Tashkinov wrote:
> > > > [...]
> > > > > > $ grep . -r /sys/devices/system/cpu/cpuidle/
> > > > > > /sys/devices/system/cpu/cpuidle/current_driver:intel_idle
> > > > > > /sys/devices/system/cpu/cpuidle/current_governor_ro:menu
> > > > 
> > > > Could you try with acpi_idle driver?
> > > > echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
> > > 
> > > [root@localhost ~]# echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
> > > -bash: /sys/devices/system/cpu/cpuidle/current_driver: Permission denied
> > 
> > It seems that this is cannot be set in runtime:
> > SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
> > 
> > Or maybe you need to boot with cpuidle_sysfs_switch. According to the
> > documentation you might be able to change the governor. I have no idea
> > whether this can help somehow but let's try that.
> > 
> > I haven't found any intel_idle machine in my lab so far and all other
> > acpi_idle machines seem to work (or at least randomly selected ones) so
> > this smells like a major difference in the setup.
> 
> I'm able to reproduce that with acpi_driver on one box, but not on demand.

And do you see the same thing (no idle/io_wait) updates?

> 
> Thanks,
> Rafael

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
