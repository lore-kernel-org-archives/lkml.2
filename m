Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1DDJVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:21:11 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36874 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1DDJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:21:09 -0400
Message-ID: <4D998D75.1080903@ahsoftware.de>
Date: Mon, 04 Apr 2011 11:20:53 +0200
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
References: <20110321204104.GA2702@kroah.com>  <4D94C666.3060206@osadl.org> <1301632555.4766.5.camel@marge.simson.net> <4D96E90D.9000905@osadl.org> <4D96F945.3030101@ahsoftware.de> <4D970818.2020707@osadl.org>
In-Reply-To: <4D970818.2020707@osadl.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 02.04.2011 13:27, schrieb Carsten Emde:

>> I'm using a
>> model name : Intel(R) Core(TM) i7 CPU 860 @ 2.80GHz
> This probably is not model 44; is it 26, 30 or 31?

Model 30, stepping 5. HT is enabled.

>> and can confirm some problem with power down, at least in 2.6.38.2.
>> Sometimes I only see the powerdown message but the machine will stay on
>> (and the fan starts getting louder).
>> [..]
>> Maybe it's a totally unrelated problem, but I thought it might be good
>> to mention that I'm having a problem with powerdown in 2.6.38 too.
> Yes, thank you,
>
> Would you mind to completely disable processor frequency scaling and
> check whether the powerdown problem goes away on your system as well? I
> do not know which distro you are using, but on some systems "chkconfig
> cpuspeed off; reboot" would do the job. When the system then reboots,
> "halt" should correctly power off the system.

I'm currently using F13, always with the latest stable vanilla kernel 
from kernel.org. No cpufreq-daemons or similiar are involved, just the 
governor "ondemand".

In regard to more detailed testing I can't say when I will find the time 
to do that. I'm using this machine regulary and the problem occurs only 
seldom (maybe 1 out of 5 shutdowns). So git bisect or similiar generic 
tests aren't very practical.

I will try to add some print statements, I assume 
native_machine_power_off() and stuff afterwards are the candidates where 
to do that.

Regards,

Alexander
