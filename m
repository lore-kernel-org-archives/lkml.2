Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2KINMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:12:53 -0500
Received: from hibox-130.abo.fi ([130.232.216.130]:55110 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab2KINMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:12:52 -0500
Message-ID: <509D014B.2080709@hibox.fi>
Date: Fri, 09 Nov 2012 15:12:43 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <508DB432.2030208@hibox.fi> <20121101190119.GA27294@quack.suse.cz> <50932DAC.7040702@hibox.fi> <20121107161730.GB23654@quack.suse.cz> <509C4339.2090506@hibox.fi>
In-Reply-To: <509C4339.2090506@hibox.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2012 01:41, Marcus Sundman wrote:
> On 07.11.2012 18:17, Jan Kara wrote:
>> On Fri 02-11-12 04:19:24, Marcus Sundman wrote:
>>> Also, and this might be important, according to iotop there is
>>> almost no disk writing going on during the freeze. (Occasionally
>>> there are a few MB/s, but mostly it's 0-200 kB/s.) Well, at least
>>> when an iotop running on nice -20 hasn't frozen completely, which it
>>> does during the more severe freezes.
>>    OK, it seems as if your machine has some problems with memory
>> allocations. Can you capture /proc/vmstat before the freeze and after 
>> the
>> freeze and send them for comparison. Maybe it will show us what is the
>> system doing.
>
> t=01:06 http://sundman.iki.fi/vmstat.pre-freeze.txt
> t=01:08 http://sundman.iki.fi/vmstat.during-freeze.txt
> t=01:12 http://sundman.iki.fi/vmstat.post-freeze.txt

Here are some more vmstats:
http://sundman.iki.fi/vmstats.tar.gz

They are from running this:
while true; do cat /proc/vmstat > "vmstat.$(date +%FT%X).txt"; sleep 10; 
done

There were lots and lots of freezes for almost 20 mins from 14:37:45 
onwards, pretty much constantly, but at 14:56:50 the freezes suddenly 
stopped and everything went back to how it should be.


Thanks,
Marcus

