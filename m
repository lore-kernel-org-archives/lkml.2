Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1DBLbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:31:12 -0400
Received: from toro.web-alm.net ([62.245.132.31]:48737 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1DBLbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:31:11 -0400
Message-ID: <4D970818.2020707@osadl.org>
Date: Sat, 02 Apr 2011 13:27:20 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Mike Galbraith <efault@gmx.de>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.33.8
References: <20110321204104.GA2702@kroah.com>  <4D94C666.3060206@osadl.org> <1301632555.4766.5.camel@marge.simson.net> <4D96E90D.9000905@osadl.org> <4D96F945.3030101@ahsoftware.de>
In-Reply-To: <4D96F945.3030101@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

>> [..]
>> This is the situation:
>>
>> 1. Without commit ea53069231f9317062910d6e772cca4ce93de8c8:
>> Everything is fine. The system correctly powers off.
>>
>> 2. With commit ea53069231f9317062910d6e772cca4ce93de8c8:
>> a) Frequency scaling never enabled (acpi_cpufreq not loaded,
>> cpufreq_ondemand not loaded):
>> Everything is fine. The system correctly powers off.
>> b) Frequency scaling enabled (acpi_cpufreq loaded, cpufreq_ondemand
>> loaded) or
>> c) Frequency scaling enabled and disabled (acpi_cpufreq still loaded
>> since it cannot be removed easily, cpufreq_ondemand no longer
>> loaded) or
>> d) Frequency scaling enabled and disabled (acpi_cpufreq unloaded
>> with force, cpufreq_ondemand no longer loaded):
>> Not powering off, message:
>> ACPI: Preparing to enter system sleep state S5
>> Disabling non-boot CPUs ...
> I'm using a
> model name : Intel(R) Core(TM) i7 CPU 860 @ 2.80GHz
This probably is not model 44; is it 26, 30 or 31?

> and can confirm some problem with power down, at least in 2.6.38.2.
> Sometimes I only see the powerdown message but the machine will stay on
> (and the fan starts getting louder).
>[..]
> Maybe it's a totally unrelated problem, but I thought it might be good
> to mention that I'm having a problem with powerdown in 2.6.38 too.
Yes, thank you,

Would you mind to completely disable processor frequency scaling and 
check whether the powerdown problem goes away on your system as well? I 
do not know which distro you are using, but on some systems "chkconfig 
cpuspeed off; reboot" would do the job. When the system then reboots, 
"halt" should correctly power off the system.

	-Carsten.
