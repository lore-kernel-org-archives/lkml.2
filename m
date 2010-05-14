Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0ENE34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:29:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58620 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0ENE3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L/+wElZlqgVdCu89qMujRMt0X8ii3efPGXHTHeX+zS6jzD70MucQhO8h7t4IdEps8o
         y0f4hhwebENdoCh7yZCvAd0QEcPTVvjuRqNndZkuF8O49ZEHjF8tqqnO30MioVH/h2ID
         7CPo5MP7JUhULEJeXEwaUjcIEJRbSIdhRu8qg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
	 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
Date: Fri, 14 May 2010 08:29:53 +0400
Message-ID: <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 14, 2010, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello Cyrill,
>
> On Fri, May 14, 2010 at 8:49 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On Friday, May 14, 2010, Jaswinder Singh Rajput
>> <jaswinderlinux@gmail.com> wrote:
>>> Hello,
>>>
>>> I am testing Performance Events on P4 with HT:
>>>
>>> [    0.002243] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
>>> [    0.002432] ... version:                0
>>> [    0.002545] ... bit width:              40
>>> [    0.002659] ... generic registers:      18
>>> [    0.002772] ... value mask:             000000ffffffffff
>>> [    0.002887] ... max period:             0000007fffffffff
>>> [    0.003004] ... fixed-purpose events:   0
>>> [    0.003118] ... event mask:             000000000003ffff
>>>
>>> dmesg : http://userweb.kernel.org/~jaswinder/P4_HT/dmesg-2634-rc7-tip.txt
>>> config : http://userweb.kernel.org/~jaswinder/P4_HT/config-2634-rc7-tip.txt
>>>
>>> [jaswinder@ht perf]$ ./perf stat -e cycles ls > /dev/null
>>>
>>>  Performance counter stats for 'ls':
>>>
>>>   <not counted>  cycles
>>>
>>>     0.003447053  seconds time elapsed
>>>
>>> [jaswinder@ht perf]$ ./perf stat -e cycles,instructions ls > /dev/null
>>>
>>>  Performance counter stats for 'ls':
>>>
>>>   <not counted>  cycles
>>>         1862188  instructions             #      0.000 IPC    (scaled
>>> from 54.91%)
>>>
>>>     0.003419230  seconds time elapsed
>>>
>>> [jaswinder@ht perf]$ ./perf stat -e
>>> cycles,instructions,cache-references ls > /dev/null
>>>
>>> <<this dumps on screen and hangs the systems>>
>>>
>>> How can I fix this problem.
>>>
>>> Thanks,
>>> --
>>> Jaswinder Singh.
>>>
>>
>> thanks for testing. Is there any issue in dmesg for first two perf
>> calls before it hangs?
>
> There is no issue in dmesg for first two perf calls.
>
>> And is there a chance for screen dump (photo or
>> netconsole)?
>>
>
> Here is netconsole :
>
> [jaswinder@ht perf]$ ./perf stat -e
> cycles,instructions,cache-references ls > /dev/null
>
> Message from syslogd@ht at May 14 09:39:32 ...
>  kernel:[  314.908284] general protection fault: 0000 [#1] PREEMPT SMP
>
> Message from syslogd@ht at May 14 09:39:32 ...
>  kernel:[  314.908296] last sysfs file:
> /sys/class/net/eth1/statistics/collisions
>
> Message from syslogd@ht at May 14 09:39:32 ...
>  kernel:[  314.908346] Process ls (pid: 2726, ti=edac2000
> task=ed9eb240 task.ti=edac2000)
>
> Message from syslogd@ht at May 14 09:39:32 ...
>  kernel:[  314.908349] Stack:
>
> Message from syslogd@ht at May 14 09:39:32 ...
>  kernel:[  314.908387] Call Trace:
>
> Message from syslogd@ht at May 14 09:39:32 ...
>  kernel:[  314.908549] Code: cb 89 d1 e8 89 c7 13 00 8b 75 dc 8b 45 e4
> 8b 55 d0 23 15 68 37 58 c1 8b b6 c4 00 00 00 01 75 f0 f7 d8 8b 4d f0
> 23 05 64 37 58 c1 <0f> 30 8b 45 dc e8 a4 63 06 00 8b 45 ec 83 c4 30 5b
> 5e 5f 5d c3
>
> Message from syslogd@ht at May 14 09:39:32 ...
>  kernel:[  314.908612] EIP: [<c100ccca>]
> x86_perf_event_set_period+0x19d/0x1b2 SS:ESP 0068:edac3d70
>
> If you need more information, please let me know.
>
> Thanks,
> --
>
> Jaswinder Singh.
>

thanks Jaswinder, i'll take a look, meanwhile if you get a chance to
test latest -tip/master it would be great
