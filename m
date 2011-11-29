Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab1K2Ws0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:48:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34624 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab1K2WsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:48:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Date: Tue, 29 Nov 2011 23:51:16 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, pomac@vapor.com,
        linux-kernel@vger.kernel.org, tino.keitel@tikei.de
References: <20111128222803.GA4925@pomac.netswarm.net> <1833322904.224056.1322571256185.JavaMail.mail@webmail07> <20111129131042.GC4043@tiehlicka.suse.cz>
In-Reply-To: <20111129131042.GC4043@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111292351.16233.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 29, 2011, Michal Hocko wrote:
> On Tue 29-11-11 12:54:16, Artem S. Tashkinov wrote:
> > > On Nov 29, 2011, Michal Hocko  wrote: 
> > > 
> > > On Tue 29-11-11 13:31:56, Michal Hocko wrote:
> > > > On Tue 29-11-11 11:38:47, Artem S. Tashkinov wrote:
> > > [...]
> > > > > $ grep . -r /sys/devices/system/cpu/cpuidle/
> > > > > /sys/devices/system/cpu/cpuidle/current_driver:intel_idle
> > > > > /sys/devices/system/cpu/cpuidle/current_governor_ro:menu
> > > 
> > > Could you try with acpi_idle driver?
> > > echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
> > 
> > [root@localhost ~]# echo acpi_idle > /sys/devices/system/cpu/cpuidle/current_driver
> > -bash: /sys/devices/system/cpu/cpuidle/current_driver: Permission denied
> 
> It seems that this is cannot be set in runtime:
> SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
> 
> Or maybe you need to boot with cpuidle_sysfs_switch. According to the
> documentation you might be able to change the governor. I have no idea
> whether this can help somehow but let's try that.
> 
> I haven't found any intel_idle machine in my lab so far and all other
> acpi_idle machines seem to work (or at least randomly selected ones) so
> this smells like a major difference in the setup.

I'm able to reproduce that with acpi_driver on one box, but not on demand.

Thanks,
Rafael
