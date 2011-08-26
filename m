Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1HZCyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 22:54:40 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:43465 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893Ab1HZCyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 22:54:37 -0400
Message-ID: <4E570AEB.1040703@profihost.ag>
Date: Fri, 26 Aug 2011 04:54:35 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: slow performance on disk/network i/o full speed after drop_caches
References: <4E5494D4.1050605@profihost.ag> <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com> <4E54BDCF.9020504@profihost.ag> <20110824093336.GB5214@localhost> <4E560F2A.1030801@profihost.ag> <20110826021648.GA19529@localhost>
In-Reply-To: <20110826021648.GA19529@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

> Ah you are running an older kernel that didn't show all the vmstat
> numbers. But still it's revealing that node 0 is used heavily and node
> 1 is almost idle. So I won't be surprised to see most free pages lie
> in node 1.
I'm running a 2.6.38 kernel.

There is at least a numastat proc file.
grep . /sys/devices/system/node/node*/numastat
/sys/devices/system/node/node0/numastat:numa_hit 5958586
/sys/devices/system/node/node0/numastat:numa_miss 0
/sys/devices/system/node/node0/numastat:numa_foreign 0
/sys/devices/system/node/node0/numastat:interleave_hit 4191
/sys/devices/system/node/node0/numastat:local_node 5885189
/sys/devices/system/node/node0/numastat:other_node 73397
/sys/devices/system/node/node1/numastat:numa_hit 488922
/sys/devices/system/node/node1/numastat:numa_miss 0
/sys/devices/system/node/node1/numastat:numa_foreign 0
/sys/devices/system/node/node1/numastat:interleave_hit 4187
/sys/devices/system/node/node1/numastat:local_node 386741
/sys/devices/system/node/node1/numastat:other_node 102181

>> modified it a little bit:
>> ~# while [ true ]; do ps -eo
>> user,pid,tid,class,rtprio,ni,pri,psr,pcpu,vsz,rss,pmem,stat,wchan:28,cmd
>> | grep scp | grep -v grep; sleep 1; done
>>
>> root     12409 12409 TS       -   0  19   0 59.8  42136  1724  0.0 Ss
>> poll_schedule_timeout        scp -t /tmp/
>
> It's mostly doing poll() waits. There must be some dependency on
> something other to make progress. Would you post the full ps output
> for all tasks, and even better, run
complete ps output:
http://pastebin.com/raw.php?i=b948svzN

>          echo t>  /proc/sysrq-trigger
sadly i wa sonly able to grab the output in this crazy format:
http://pastebin.com/raw.php?i=MBXvvyH1

Hope that still helps.

Thanks Stefan
