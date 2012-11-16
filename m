Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab2KPBLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:11:33 -0500
Received: from hibox-130.abo.fi ([130.232.216.130]:54007 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2KPBLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:11:32 -0500
Message-ID: <50A592BA.8050709@hibox.fi>
Date: Fri, 16 Nov 2012 03:11:22 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <508DB432.2030208@hibox.fi> <20121101190119.GA27294@quack.suse.cz> <50932DAC.7040702@hibox.fi> <20121107161730.GB23654@quack.suse.cz> <509C4339.2090506@hibox.fi> <509D014B.2080709@hibox.fi> <20121113135159.GA18651@quack.suse.cz>
In-Reply-To: <20121113135159.GA18651@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.2012 15:51, Jan Kara wrote:
> On Fri 09-11-12 15:12:43, Marcus Sundman wrote:
>> On 09.11.2012 01:41, Marcus Sundman wrote:
>>> On 07.11.2012 18:17, Jan Kara wrote:
>>>> On Fri 02-11-12 04:19:24, Marcus Sundman wrote:
>>>>> Also, and this might be important, according to iotop there is
>>>>> almost no disk writing going on during the freeze. (Occasionally
>>>>> there are a few MB/s, but mostly it's 0-200 kB/s.) Well, at least
>>>>> when an iotop running on nice -20 hasn't frozen completely, which it
>>>>> does during the more severe freezes.
>>>>    OK, it seems as if your machine has some problems with memory
>>>> allocations. Can you capture /proc/vmstat before the freeze and
>>>> after the
>>>> freeze and send them for comparison. Maybe it will show us what is the
>>>> system doing.
>>> t=01:06 http://sundman.iki.fi/vmstat.pre-freeze.txt
>>> t=01:08 http://sundman.iki.fi/vmstat.during-freeze.txt
>>> t=01:12 http://sundman.iki.fi/vmstat.post-freeze.txt
>> Here are some more vmstats:
>> http://sundman.iki.fi/vmstats.tar.gz
>>
>> They are from running this:
>> while true; do cat /proc/vmstat > "vmstat.$(date +%FT%X).txt"; sleep
>> 10; done
>>
>> There were lots and lots of freezes for almost 20 mins from 14:37:45
>> onwards, pretty much constantly, but at 14:56:50 the freezes
>> suddenly stopped and everything went back to how it should be.
>    I was looking into the data but they didn't show anything problematic.
> The machine seems to be writing a lot but there's always some free memory,
> even direct reclaim isn't ever entered. Hum, actually you wrote iotop isn't
> showing much IO going on but vmstats show there is about 1 GB written
> during the freeze. It is not a huge amount given the time span but it
> certainly gives a few MB/s of write load.

I didn't watch iotop during this particular freeze. I'll try to keep an 
eye on iotop in the future. Is there some particular options I should 
run iotop with, or is a "nice -n -20 iotop -od3" fine?

> There's surprisingly high number of allocations going on but that may be
> due to the IO activity. So let's try something else: Can you switch to
> console and when the hang happens press Alt-Sysrq-w (or you can just do
> "echo w >/proc/sysrq-trigger" if the machine is live enough to do that).
> Then send me the output from dmesg.  Thanks!

Sure! Here are two:
http://sundman.iki.fi/dmesg-1.txt
http://sundman.iki.fi/dmesg-2.txt


Best regards,
Marcus

