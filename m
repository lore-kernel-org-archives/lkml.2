Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2AYXok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:44:40 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52647 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2AYXoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:44:39 -0500
Date: Wed, 25 Jan 2012 15:44:24 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: "David H. Durgee" <dhdurgee@verizon.net>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: Request for assistance - excessive kworker CPU wakeups
Message-ID: <20120125234424.GL4656@google.com>
References: <4EE27D28.4040909@verizon.net>
 <CACBanvpV7pWp07jzuYqzRkbkShvvKvpcu6yFsLfEL+UhT8kp_g@mail.gmail.com>
 <4F205056.2020002@verizon.net>
MIME-Version: 1.0
In-Reply-To: <4F205056.2020002@verizon.net>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David H. Durgee (dhdurgee@verizon.net) wrote:
> Mandeep Singh Baines wrote:
> >On Fri, Dec 9, 2011 at 1:27 PM, David H. Durgee<dhdurgee@verizon.net>  wrote:
> >>I recently purchased a Lenovo IdeaPad Z560, model 09143YU, and as I am not a
> >>Windows fan I installed Linux Mint 11 Katya x64 to use instead of the
> >>supplied W7.  I was encountering a known hang and had to upgrade to a later
> >>kernel, so I am now using the 2.6.38-11-generic #50-Ubuntu SMP Mon Sep 12
> >>21:17:25 UTC 2011 x86_64 kernel.
> >>
> >>I had my first occasion to use the laptop for an extended period for the
> >>first time over the Thanksgiving holiday and I found it needed to be tuned.
> >>  I downloaded powertop and used it to discover where my problems were.
> >>  After addressing excessive i915 interrupts due to DRI the next most
> >>frequent cause of CPU wakeups is a kworker on the system.  A search lead to
> >>a post by Tejun, indicating the need to trace such issues. Running the trace
> >>showed that 1933 of 2748 events were of the form:
> >>
> >><idle>-0     [000] 22005.355346: workqueue_queue_work: work
> >>struct=ffff8800bb411188 function=do_dbs_timer workqueue=ffff88012b5d2c00
> >>req_cpu=0 cpu=0
> >>
> >>Tejun indicated that this is a workitem used by cpufreq and likely caused by
> >>something else hitting the CPU frequently.  So how do I diagnose this
> >>further and isolate the cause for correction?
> >>
> >>If you would like a summary of this, download this spreadsheet:
> >>
> >>http://home.comcast.net/%7Eddurgee/Tracelog.ods
> >>
> >>If you would like to inspect the trace log itself:
> >>
> >>http://home.comcast.net/%7Eddurgee/tracelog.zip
> >>
> >Hi Dave,
> >
> >I don't know the cpufreq code that well, but it seem that this
> >workqueue is schedule periodically. You
> >can examine the sampling rate via /sys:
> >
> >$ grep "" /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate*
> >
> >Just curious, are you running nohz:
> >
> >$ dmesg | grep -i nohz
> >
> >Regards,
> >Mandeep
> dhdurgee@DHD-Z560 ~/Downloads $ grep ""
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate*
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate:10000
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_max:4294967295
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_min:10000
> dhdurgee@DHD-Z560 ~/Downloads $ dmesg | grep -i nohz
> dhdurgee@DHD-Z560 ~/Downloads $
> 
> Does this explain what I am seeing?  Does this square with the
> observations in my spreadsheet?  Does this suggest a means of
> reducing these excessive wakeups?  Is there more information I can
> provide to suggest a course of action?
> 

IIUC, you should be seeing 100 such events per second * number of CPUs.
Is that what you are seeing? You could reduce this by changing HZ. Maybe
change to CONFIG_HZ_100 in your .config from CONFIG_HZ_1000. That
should reduce the number of events by a factor of 10.

Regards,
Mandeep

> Dave
