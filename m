Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2AYRoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:44:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61580 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab2AYRoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:44:15 -0500
MIME-Version: 1.0
In-Reply-To: <4EE27D28.4040909@verizon.net>
References: <4EE27D28.4040909@verizon.net>
Date: Wed, 25 Jan 2012 09:44:14 -0800
X-Google-Sender-Auth: Q4pA_ioS5xB18WJjCiNzrtHoXFw
Message-ID: <CACBanvpV7pWp07jzuYqzRkbkShvvKvpcu6yFsLfEL+UhT8kp_g@mail.gmail.com>
Subject: Re: Request for assistance - excessive kworker CPU wakeups
From: Mandeep Singh Baines <msb@chromium.org>
To: "David H. Durgee" <dhdurgee@verizon.net>
Cc: linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 1:27 PM, David H. Durgee <dhdurgee@verizon.net> wrote:
> I recently purchased a Lenovo IdeaPad Z560, model 09143YU, and as I am not a
> Windows fan I installed Linux Mint 11 Katya x64 to use instead of the
> supplied W7.  I was encountering a known hang and had to upgrade to a later
> kernel, so I am now using the 2.6.38-11-generic #50-Ubuntu SMP Mon Sep 12
> 21:17:25 UTC 2011 x86_64 kernel.
>
> I had my first occasion to use the laptop for an extended period for the
> first time over the Thanksgiving holiday and I found it needed to be tuned.
>  I downloaded powertop and used it to discover where my problems were.
>  After addressing excessive i915 interrupts due to DRI the next most
> frequent cause of CPU wakeups is a kworker on the system.  A search lead to
> a post by Tejun, indicating the need to trace such issues. Running the trace
> showed that 1933 of 2748 events were of the form:
>
> <idle>-0     [000] 22005.355346: workqueue_queue_work: work
> struct=ffff8800bb411188 function=do_dbs_timer workqueue=ffff88012b5d2c00
> req_cpu=0 cpu=0
>
> Tejun indicated that this is a workitem used by cpufreq and likely caused by
> something else hitting the CPU frequently.  So how do I diagnose this
> further and isolate the cause for correction?
>
> If you would like a summary of this, download this spreadsheet:
>
> http://home.comcast.net/%7Eddurgee/Tracelog.ods
>
> If you would like to inspect the trace log itself:
>
> http://home.comcast.net/%7Eddurgee/tracelog.zip
>

Hi Dave,

I don't know the cpufreq code that well, but it seem that this
workqueue is schedule periodically. You
can examine the sampling rate via /sys:

$ grep "" /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate*

Just curious, are you running nohz:

$ dmesg | grep -i nohz

Regards,
Mandeep

> Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
