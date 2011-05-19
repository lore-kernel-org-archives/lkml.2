Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab1ESP5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:57:21 -0400
Received: from dell.nexicom.net ([216.168.96.13]:50809 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab1ESP5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:57:19 -0400
Message-ID: <4DD53E01.7060509@lockie.ca>
Date: Thu, 19 May 2011 11:57:53 -0400
From: James <bjlockie@lockie.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110512 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: help to bisect
References: <4DD31264.4070704@lockie.ca> <20110518072245.GB17608@liondog.tnic> <4DD42F10.90602@lockie.ca> <20110518211723.GA4313@liondog.tnic> <4DD45D2D.7060300@lockie.ca> <20110519074722.GD14049@liondog.tnic>
In-Reply-To: <20110519074722.GD14049@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/11 03:47, Borislav Petkov wrote:
> On Wed, May 18, 2011 at 07:58:37PM -0400, James wrote:
>> On 05/18/11 17:17, Borislav Petkov wrote:
>>> First of all, please hit "reply-to-all" next time so that all recipients
>>> can receive your mail and not find it by chance when looking thru the
>>> new lkml messages.
>>>
>>> On Wed, May 18, 2011 at 04:41:52PM -0400, James wrote:
>>>> Here is what I did:
>>>>
>>>> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
>>>> $ cd linux-2.6.37.y
>>>> $ git checkout v2.6.36
>>>> build and boot kernel
>>> what does that mean? Is .36 ok?
>> Yes, no problems.
>>>> $ cd linux-2.6.37.y
>>>> $ git bisect start
>>>> $ git bisect good v2.6.36
>>>> $ git bisect bad v2.6.37.6
>>> Also, is .37.6 bad?
>> Yes, it is bad.
>>>> build and boot kernel
>>>> git bisect good|bad
>>>> repeat
>>>>
>>>> 3044100e58c84e133791c8b60a2f5bef69d732e4 is the first bad commit.
>>> Which is a merge commit and it means that you most likely made a mistake
>>> during bisection.
>> Am I doing it right?
>> boot kernel, cd to git source, git bisect good or bad, compile new
>> kernel and copy it to /boot,
> Dumb question: do you boot into that new kernel and test it each time
> before tagging it as good or bad?
Yes, I boot the new kernel.
I also did 'make clean' and 'make oldconfig' before I built each kernel.
>> repeat
>>> What is actually the problem you're experiencing with .37.6?
>>>
>>> ..
>>>
>>>> How do I find out what change causes the problem?
>>>> The problem causes my wireless card not to work.
>>> Ah, here it is.
>>>
>>>> Other people have similar cards that do work so the problem seems
>>>> isolated to my hardware but kernel-2.6.36 works so I don't think my
>>>> hardware is faulty.
>>> Which card is that? (adding linux-wireless)
>> D-Link dwa552
>> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>> mem=0xffffc90000140
>> 000, irq=16
>> Other people have this card working so it is probably my system
>> configuration that is causing an obscure bug.
>>
>>> Please, describe in a very detailed way how your problem incarnates
>>> itself: dmesg, error messages, what exactly do you do to trigger it?
>> It seems to be 100% that if "ath: Failed to stop TX DMA in 100 msec
>> after killing last frame
>> ath: Failed to stop TX DMA!" shows up in dmesg that scans don't return
>> any APs or 1-3 (iwlist wlan0 scan | grep SSID).
>> If there is a different way to scan, I'll try that.
>>
>>
>>
>>> Also, can you test whether 38.6 works for ya - it could've been fixed in
>>> the meantime. You can also test .39 which will be released any minute
>>> now.
>> 38.6 does NOT work and compat-wireless-2011-05-11 works on kernel-2.6.36
>> which is why I think it is the kernel and not the wireless code.
>>> I think that should be enough for now.
> Aha, here's the deal. You're using compat-wireless which is a bunch of
> patches ontop of the kernel so you want to add them to the repository
> you're bisecting in so that they can be considered too. Anyway, I've
> added Luis to Cc for comment.
I made a typo, I tried compatwireless to kernel-2.6.36.4 to make sure.
None of the kernels I bisected had compatwireless.
> @Luis: bug descrption is above.
>
> Btw, there's a newer version against 2.6.39-rc6 which you might want to
> test too: http://marc.info/?l=linux-wireless&m=130455450126421&w=2
>
> HTH.
I built http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.tar.bz2

I tried to compile
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/compat-wireless-2.6.39-rc6-1-sp.tar.bz2
./scripts/gen-compat-autoconf.sh config.mk >
include/linux/compat_autoconf.h   
make -C /lib/modules/2.6.38.6/build
M=/usr/src/compat-wireless-2.6.39-rc6-1-sp
modules                                                                         

make[1]: Entering directory
`/usr/src/linux-2.6.38.6'                          
  CC [M] 
/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat/main.o               
  CC [M] 
/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat/compat-2.6.39.o      
/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat/compat-2.6.39.c: In
function
'tty_set_termios':                                                                

/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat/compat-2.6.39.c:93:
error: 'TASK_INTERRUPTIBLE' undeclared (first use in this
function)                        
/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat/compat-2.6.39.c:93:
error: (Each undeclared identifier is reported only
once                                   
/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat/compat-2.6.39.c:93:
error: for each function it appears
in.)                                                   
make[3]: ***
[/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat/compat-2.6.39.o] Error
1                                                                         
make[2]: *** [/usr/src/compat-wireless-2.6.39-rc6-1-sp/compat] Error
2         
make[1]: *** [_module_/usr/src/compat-wireless-2.6.39-rc6-1-sp] Error
2        
make[1]: Leaving directory
`/usr/src/linux-2.6.38.6'                           
make: *** [modules] Error
2                                                    

I wonder if it could be simply something is missing in my .config
I put it on http://lockie.ca/test/config.bz2

This is the first kernel that doesn't work that displays the dmesg
errors after I try a scan.
Usually the messages show up immediately.

I can't reproduce this but this was in dmesg the first time I booted:

ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
DMADBG_7=0x000062c0
ath: Could not stop RX, we could be confusing the DMA engine when we
start RX up
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/recv.c:507
ath_stoprecv+0xcf/0xf1 [ath9k]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: ath9k mac80211 ath9k_common ath9k_hw ath cfg80211
Pid: 699, comm: kworker/u:4 Not tainted 2.6.39 #1
Call Trace:
 [<ffffffff81029eb8>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffffa00bfd90>] ? ath_stoprecv+0xcf/0xf1 [ath9k]
 [<ffffffffa00bd6fb>] ? ath_set_channel+0xce/0x273 [ath9k]
 [<ffffffffa002485f>] ? ath_hw_cycle_counters_update+0xdf/0x123 [ath]
 [<ffffffffa00bdbc0>] ? ath9k_config+0x320/0x435 [ath9k]
 [<ffffffffa008b796>] ? ieee80211_scan_work+0x2e7/0x456 [mac80211]
 [<ffffffffa008b4af>] ? ieee80211_scan_completed+0x29/0x29 [mac80211]
 [<ffffffff8103b7fa>] ? process_one_work+0x20e/0x34e
 [<ffffffff8103bd39>] ? worker_thread+0x1c9/0x340
 [<ffffffff81020af5>] ? __wake_up_common+0x41/0x78
 [<ffffffff8103bb70>] ? rescuer_thread+0x236/0x236
 [<ffffffff8103bb70>] ? rescuer_thread+0x236/0x236
 [<ffffffff8103eb4a>] ? kthread+0x7a/0x82
 [<ffffffff8133a9d4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8103ead0>] ? kthread_worker_fn+0x107/0x107
 [<ffffffff8133a9d0>] ? gs_change+0xb/0xb
---[ end trace 7d1c5ea6cf770ada ]---

I put the full dmesg output on I put it on
http://lockie.ca/test/dmesg.txt.bz2
