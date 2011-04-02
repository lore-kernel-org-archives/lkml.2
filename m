Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1DBKYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 06:24:23 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43273 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1DBKYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 06:24:22 -0400
Message-ID: <4D96F945.3030101@ahsoftware.de>
Date: Sat, 02 Apr 2011 12:24:05 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Carsten Emde <C.Emde@osadl.org>
CC: Mike Galbraith <efault@gmx.de>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.33.8
References: <20110321204104.GA2702@kroah.com>  <4D94C666.3060206@osadl.org> <1301632555.4766.5.camel@marge.simson.net> <4D96E90D.9000905@osadl.org>
In-Reply-To: <4D96E90D.9000905@osadl.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 02.04.2011 11:14, schrieb Carsten Emde:
> model name : Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz
> stepping : 2
>
> This is the situation:
>
> 1. Without commit ea53069231f9317062910d6e772cca4ce93de8c8:
> Everyting is fine. The system correctly powers off.
>
> 2. With commit ea53069231f9317062910d6e772cca4ce93de8c8:
> a) Frequency scaling never enabled (acpi_cpufreq not loaded,
> cpufreq_ondemand not loaded):
> Everything is fine. The system correctly powers off.
> b) Frequency scaling enabled (acpi_cpufreq loaded, cpufreq_ondemand
> loaded) or
> c) Frequency scaling enabled and disabled (acpi_cpufreq still loaded
> since it cannot be removed easily, cpufreq_ondemand no longer
> loaded) or
> d) Frequency scaling enabled and disabled (acpi_cpufreq unloaded
> with force, cpufreq_ondemand no longer loaded):
> Not powering off, message:
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...

I'm using a

model name      : Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz

and can confirm some problem with power down, at least in 2.6.38.2. 
Sometimes I only see the powerdown message but the machine will stay on 
(and the fan starts getting louder).

But in contrast to the above description (that commit seems to have been 
already included in 2.6.37), I never had a problem with powerdown with a 
kernel <2.6.38.
I have CONFIG_X86_ACPI_CPUFREQ enabled, but I currently can't offer much 
more insights, because I haven't tried to analyze that problem. The 
problem doesn't appear with any shutdown, and I don't know (and can't 
remember) if that already happened with 2.6.38.

Besides switching from BKL to non-BKL, I haven't changed the config when 
I've switched from 2.6.37.x to 2.6.38 (other than what make oldconfig does).

Maybe it's a totally unrelated problem, but I thought it might be good 
to mention that I'm having a problem with powerdown in 2.6.38 too.

Regards,

Alexander Holler
