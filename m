Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2KHXmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 18:42:16 -0500
Received: from hibox-130.abo.fi ([130.232.216.130]:59230 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757234Ab2KHXmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 18:42:15 -0500
Message-ID: <509C4339.2090506@hibox.fi>
Date: Fri, 09 Nov 2012 01:41:45 +0200
From: Marcus Sundman <marcus@hibox.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
References: <508DB432.2030208@hibox.fi> <20121101190119.GA27294@quack.suse.cz> <50932DAC.7040702@hibox.fi> <20121107161730.GB23654@quack.suse.cz>
In-Reply-To: <20121107161730.GB23654@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam_score: -2.7
X-Spam_bar: --
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.2012 18:17, Jan Kara wrote:
> On Fri 02-11-12 04:19:24, Marcus Sundman wrote:
>> On 01.11.2012 21:01, Jan Kara wrote:
>>> On Mon 29-10-12 00:39:46, Marcus Sundman wrote:
>>>    Hello,
>>>
>>>> I have a big problem with the system freezing and would appreciate
>>>> any help on debugging this and pinpointing where exactly the problem
>>>> is, so it could be fixed.
>>>>
>>>> So, whenever I write to the disk the system comes to a crawl or
>>>> freezes altogether. This happens even when the writing processes are
>>>> running on nice '19' and ionice 'idle'. (E.g. a 10 second compile
>>>> could freeze the system for several minutes, rendering the computer
>>>> pretty much unusable for anything interesting.)
>>>>
>>>> Here you can see a 20 second gap even in superhigh priority:
>>>> # nice -n -20 ionice -c1 iostat -t -m -d -x 1 > http://pastebin.com/j5qnh2VV
>>>>
>>>> I'm currently running 3.5.0-17-lowlatency on the ZenBook UX31E,
>>>> using the NOOP I/O scheduler on the SanDisk SSD U100. The chipset
>>>> seems to be Intel QS67. I've had this same problem on 3.2.0 generic
>>>> and lowlatency kernels.
>>>    These are Ubuntu kernels. Any chance to reproduce the issue with vanilla
>>> kernels - i.e. kernels without any Ubuntu patches?
>> I'm afraid it's going to take a week to compile a kernel with this
>> freezing going on, but I suppose I could get another computer to do
>> the compiling. Or should I install some pre-compiled version? If so,
>> which one?
>    You can install anything precompiled. It's just that I want to rule out
> some Ubuntu specific patches...

OK, I tried it with a vanilla 3.6.6 -- "uname -a" says "Linux hal 
3.6.6-030606-generic #201211050512 SMP Mon Nov 5 10:12:53 UTC 2012 
x86_64 x86_64 x86_64 GNU/Linux"

>>> Also when you speak of
>>> system freezing - can you e.g. type to terminal while the system is frozen?
>>> Or is it just that running commands freezes?
>> Typing usually doesn't work very well. It works for a word or two
>> and then stops working for a while and if I continue to type then
>> when it resumes only the last few characters appears. Typing in the
>> console is a bit better than in a terminal in X (not counting the
>> several minutes it can take to switch to the console (Ctrl-Alt-F1)).
>    I see.
>
>> Also, and this might be important, according to iotop there is
>> almost no disk writing going on during the freeze. (Occasionally
>> there are a few MB/s, but mostly it's 0-200 kB/s.) Well, at least
>> when an iotop running on nice -20 hasn't frozen completely, which it
>> does during the more severe freezes.
>    OK, it seems as if your machine has some problems with memory
> allocations. Can you capture /proc/vmstat before the freeze and after the
> freeze and send them for comparison. Maybe it will show us what is the
> system doing.

t=01:06 http://sundman.iki.fi/vmstat.pre-freeze.txt
t=01:08 http://sundman.iki.fi/vmstat.during-freeze.txt
t=01:12 http://sundman.iki.fi/vmstat.post-freeze.txt

>    Also you can try doing:
> echo never >/sys/kernel/mm/transparent_hugepage/enabled
>    and see whether it changes anything.

It's already set to 'nerver'. I think I configured this in the very 
beginning when trying to do something about these freezes.

I also have these in sysctl:
vm.swappiness=1
vm.vfs_cache_pressure=50
vm.dirty_ratio = 15
vm.dirty_background_ratio = 8

And /sys/block/sda/device/queue_depth is 1.


Regards,
Marcus

