Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1ESMG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:06:56 -0400
Received: from ns2.q-leap.de ([88.79.172.217]:40812 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1ESMGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:06:55 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 08:06:54 EDT
Message-ID: <4DD50584.4010408@q-leap.de>
Date: Thu, 19 May 2011 13:56:52 +0200
From: Peter Kruse <pk@q-leap.de>
Organization: Q-Leap Networks GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: David Rientjes <rientjes@google.com>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
References: <4D53FE43.8030106@q-leap.com>    <alpine.DEB.2.00.1102141046170.26158@router.home>    <4D5A2EDB.8060603@q-leap.com>    <alpine.DEB.2.00.1102151040560.10511@router.home>    <4D5BC16A.2090205@q-leap.com>    <alpine.DEB.2.00.1102160956250.27814@router.home> <4D5BF56F.1000504@q-leap.com>    <alpine.DEB.2.00.1102161010330.27814@router.home>    <4D5CCEED.3010501@q-leap.com>    <alpine.DEB.2.00.1102171102520.11140@router.home> <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com> <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home> <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com> <4DA54D2A.3050206@q-leap.de> <alpine.DEB.2.00.1104131116330.19493@router.home>
In-Reply-To: <alpine.DEB.2.00.1104131116330.19493@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: multipart/mixed;
 boundary="------------090108070906030405080108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090108070906030405080108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello again,

you may remember, we have a server running 2.6.32.29
and once in a while it just crashes, meaning that
it just stops responding, and we have to reset it.
The kernel itself and some processes are still running,
and it is possible to initiate the sysRQ.
The mentioned allocation failures are gone after the update
to the kernel version, but the server crashed again
after 40 days running without any problem.

At this time kswapd0/1 started to consume 99% CPU time
and until the server was reset 8 hours later
never used less than 50% CPU time.  Shortly after
that (half an hour) the disk reads dropped down to zero.  And
a program produced the attached Call Trace.  I also
attach the process information of kswapd (provided by collectl).

Thanks,

  Peter

On 04/13/2011 06:17 PM, Christoph Lameter wrote:
> On Wed, 13 Apr 2011, Peter Kruse wrote:
> 
>> Hello,
>>
>> thanks for your replies, I appreciate that.
>>
>> On 04/13/2011 03:34 AM, David Rientjes wrote:
>>> On Tue, 12 Apr 2011, Christoph Lameter wrote:
>>>
>>>> The problem maybe that you have lots and lots of SCSI devices which
>>>> consume ZONE_DMA memory for their control structures. I guess that is
>>>> oversubscribing the 16M zone.
>>
>> but there are only two devices:
> 
> The output you sent me showed a long list of devices. Maybe there is a
> broken driver /device that continues being probed?
> 


-- 
Peter Kruse <pk@q-leap.de>
Q-Leap Networks GmbH
phone: +497034-2776-175, mobile: +491522-1593877

--------------090108070906030405080108
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages"

May 16 02:24:36 beosrv1-t kernel: [3504667.830773] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:24:36 beosrv1-t kernel: [3504667.830797]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:24:36 beosrv1-t kernel: [3504667.830826]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:24:36 beosrv1-t kernel: [3504667.830854]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:24:36 beosrv1-t kernel: [3504667.830882] Call Trace:
May 16 02:24:36 beosrv1-t kernel: [3504667.830899]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:24:36 beosrv1-t kernel: [3504667.830918]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:24:36 beosrv1-t kernel: [3504667.830939]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:24:36 beosrv1-t kernel: [3504667.830957]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:24:36 beosrv1-t kernel: [3504667.830975]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:24:36 beosrv1-t kernel: [3504667.830991]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:24:36 beosrv1-t kernel: [3504667.831011]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:24:36 beosrv1-t kernel: [3504667.831027]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:24:36 beosrv1-t kernel: [3504667.831045]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:24:36 beosrv1-t kernel: [3504667.831076]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:24:36 beosrv1-t kernel: [3504667.831111]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:24:36 beosrv1-t kernel: [3504667.831146]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:24:36 beosrv1-t kernel: [3504667.831177]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:24:36 beosrv1-t kernel: [3504667.831209]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:26:35 beosrv1-t kernel: [3504787.810748] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:26:35 beosrv1-t kernel: [3504787.810773]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:26:35 beosrv1-t kernel: [3504787.810802]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:26:35 beosrv1-t kernel: [3504787.810829]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:26:35 beosrv1-t kernel: [3504787.810857] Call Trace:
May 16 02:26:35 beosrv1-t kernel: [3504787.810875]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:26:35 beosrv1-t kernel: [3504787.810893]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:26:35 beosrv1-t kernel: [3504787.810914]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:26:35 beosrv1-t kernel: [3504787.810932]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:26:35 beosrv1-t kernel: [3504787.810950]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:26:35 beosrv1-t kernel: [3504787.810966]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:26:35 beosrv1-t kernel: [3504787.810985]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:26:35 beosrv1-t kernel: [3504787.811002]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:26:35 beosrv1-t kernel: [3504787.811020]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:26:35 beosrv1-t kernel: [3504787.811051]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:26:35 beosrv1-t kernel: [3504787.811086]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:26:35 beosrv1-t kernel: [3504787.811121]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:26:35 beosrv1-t kernel: [3504787.811152]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:26:35 beosrv1-t kernel: [3504787.811184]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:28:35 beosrv1-t kernel: [3504907.579079] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:28:35 beosrv1-t kernel: [3504907.579103]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:28:35 beosrv1-t kernel: [3504907.579132]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:28:35 beosrv1-t kernel: [3504907.579160]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:28:35 beosrv1-t kernel: [3504907.579188] Call Trace:
May 16 02:28:35 beosrv1-t kernel: [3504907.579205]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:28:35 beosrv1-t kernel: [3504907.579224]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:28:35 beosrv1-t kernel: [3504907.579244]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:28:35 beosrv1-t kernel: [3504907.579262]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:28:35 beosrv1-t kernel: [3504907.579280]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:28:35 beosrv1-t kernel: [3504907.579296]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:28:35 beosrv1-t kernel: [3504907.579316]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:28:35 beosrv1-t kernel: [3504907.579333]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:28:35 beosrv1-t kernel: [3504907.579351]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:28:35 beosrv1-t kernel: [3504907.579383]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:28:35 beosrv1-t kernel: [3504907.579418]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:28:35 beosrv1-t kernel: [3504907.579453]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:28:35 beosrv1-t kernel: [3504907.579484]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:28:35 beosrv1-t kernel: [3504907.579516]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:30:35 beosrv1-t kernel: [3505027.351433] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:30:35 beosrv1-t kernel: [3505027.351458]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:30:35 beosrv1-t kernel: [3505027.351487]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:30:35 beosrv1-t kernel: [3505027.351515]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:30:35 beosrv1-t kernel: [3505027.351543] Call Trace:
May 16 02:30:35 beosrv1-t kernel: [3505027.351560]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:30:35 beosrv1-t kernel: [3505027.351578]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:30:35 beosrv1-t kernel: [3505027.351599]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:30:35 beosrv1-t kernel: [3505027.351617]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:30:35 beosrv1-t kernel: [3505027.351635]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:30:35 beosrv1-t kernel: [3505027.351652]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:30:35 beosrv1-t kernel: [3505027.351671]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:30:35 beosrv1-t kernel: [3505027.351688]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:30:35 beosrv1-t kernel: [3505027.351705]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:30:35 beosrv1-t kernel: [3505027.351737]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:30:35 beosrv1-t kernel: [3505027.351771]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:30:35 beosrv1-t kernel: [3505027.351806]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:30:35 beosrv1-t kernel: [3505027.351838]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:30:35 beosrv1-t kernel: [3505027.351869]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:32:35 beosrv1-t kernel: [3505147.119797] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:32:35 beosrv1-t kernel: [3505147.119822]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:32:35 beosrv1-t kernel: [3505147.119851]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:32:35 beosrv1-t kernel: [3505147.119879]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:32:35 beosrv1-t kernel: [3505147.119907] Call Trace:
May 16 02:32:35 beosrv1-t kernel: [3505147.119924]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:32:35 beosrv1-t kernel: [3505147.119942]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:32:35 beosrv1-t kernel: [3505147.119963]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:32:35 beosrv1-t kernel: [3505147.119982]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:32:35 beosrv1-t kernel: [3505147.120000]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:32:35 beosrv1-t kernel: [3505147.120016]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:32:35 beosrv1-t kernel: [3505147.120036]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:32:35 beosrv1-t kernel: [3505147.120053]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:32:35 beosrv1-t kernel: [3505147.120070]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:32:35 beosrv1-t kernel: [3505147.120102]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:32:35 beosrv1-t kernel: [3505147.120137]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:32:35 beosrv1-t kernel: [3505147.120171]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:32:35 beosrv1-t kernel: [3505147.120203]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:32:35 beosrv1-t kernel: [3505147.120234]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:34:35 beosrv1-t kernel: [3505266.888143] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:34:35 beosrv1-t kernel: [3505266.888168]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:34:35 beosrv1-t kernel: [3505266.888197]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:34:35 beosrv1-t kernel: [3505266.888225]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:34:35 beosrv1-t kernel: [3505266.888253] Call Trace:
May 16 02:34:35 beosrv1-t kernel: [3505266.888270]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:34:35 beosrv1-t kernel: [3505266.888288]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:34:35 beosrv1-t kernel: [3505266.888309]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:34:35 beosrv1-t kernel: [3505266.888327]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:34:35 beosrv1-t kernel: [3505266.888345]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:34:35 beosrv1-t kernel: [3505266.888361]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:34:35 beosrv1-t kernel: [3505266.888381]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:34:35 beosrv1-t kernel: [3505266.888398]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:34:35 beosrv1-t kernel: [3505266.888415]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:34:35 beosrv1-t kernel: [3505266.888447]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:34:35 beosrv1-t kernel: [3505266.888482]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:34:35 beosrv1-t kernel: [3505266.888517]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:34:35 beosrv1-t kernel: [3505266.888548]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:34:35 beosrv1-t kernel: [3505266.888579]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:36:35 beosrv1-t kernel: [3505386.656500] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:36:35 beosrv1-t kernel: [3505386.656525]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:36:35 beosrv1-t kernel: [3505386.656553]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:36:35 beosrv1-t kernel: [3505386.656581]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:36:35 beosrv1-t kernel: [3505386.656609] Call Trace:
May 16 02:36:35 beosrv1-t kernel: [3505386.656626]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:36:35 beosrv1-t kernel: [3505386.656644]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:36:35 beosrv1-t kernel: [3505386.656666]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:36:35 beosrv1-t kernel: [3505386.656684]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:36:35 beosrv1-t kernel: [3505386.656701]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:36:35 beosrv1-t kernel: [3505386.656717]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:36:35 beosrv1-t kernel: [3505386.656737]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:36:35 beosrv1-t kernel: [3505386.656754]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:36:35 beosrv1-t kernel: [3505386.656771]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:36:35 beosrv1-t kernel: [3505386.656803]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:36:35 beosrv1-t kernel: [3505386.656838]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:36:35 beosrv1-t kernel: [3505386.656872]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:36:35 beosrv1-t kernel: [3505386.656904]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:36:35 beosrv1-t kernel: [3505386.656935]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:38:35 beosrv1-t kernel: [3505506.424861] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:38:35 beosrv1-t kernel: [3505506.424886]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:38:35 beosrv1-t kernel: [3505506.424915]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:38:35 beosrv1-t kernel: [3505506.424943]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:38:35 beosrv1-t kernel: [3505506.424971] Call Trace:
May 16 02:38:35 beosrv1-t kernel: [3505506.424988]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:38:35 beosrv1-t kernel: [3505506.425006]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:38:35 beosrv1-t kernel: [3505506.425027]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:38:35 beosrv1-t kernel: [3505506.425045]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:38:35 beosrv1-t kernel: [3505506.425063]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:38:35 beosrv1-t kernel: [3505506.425079]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:38:35 beosrv1-t kernel: [3505506.425099]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:38:35 beosrv1-t kernel: [3505506.425116]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:38:35 beosrv1-t kernel: [3505506.425134]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:38:35 beosrv1-t kernel: [3505506.425165]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:38:35 beosrv1-t kernel: [3505506.425200]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:38:35 beosrv1-t kernel: [3505506.425235]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:38:35 beosrv1-t kernel: [3505506.425266]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:38:35 beosrv1-t kernel: [3505506.425298]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:40:35 beosrv1-t kernel: [3505626.404818] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:40:35 beosrv1-t kernel: [3505626.404843]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:40:35 beosrv1-t kernel: [3505626.404872]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:40:35 beosrv1-t kernel: [3505626.404900]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:40:35 beosrv1-t kernel: [3505626.404928] Call Trace:
May 16 02:40:35 beosrv1-t kernel: [3505626.404945]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:40:35 beosrv1-t kernel: [3505626.404963]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:40:35 beosrv1-t kernel: [3505626.404984]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:40:35 beosrv1-t kernel: [3505626.405002]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:40:35 beosrv1-t kernel: [3505626.405020]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:40:35 beosrv1-t kernel: [3505626.405036]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:40:35 beosrv1-t kernel: [3505626.405056]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:40:35 beosrv1-t kernel: [3505626.405073]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:40:35 beosrv1-t kernel: [3505626.405091]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:40:35 beosrv1-t kernel: [3505626.405122]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:40:35 beosrv1-t kernel: [3505626.405157]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:40:35 beosrv1-t kernel: [3505626.405192]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:40:35 beosrv1-t kernel: [3505626.405223]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:40:35 beosrv1-t kernel: [3505626.405255]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
May 16 02:42:36 beosrv1-t kernel: [3505746.348825] pv            D ffffffffffffffff     0 20917  10814 0x00000000
May 16 02:42:36 beosrv1-t kernel: [3505746.348849]  ffff8806e77f5c88 0000000000000082 ffff8806e77f5be8 ffffffff8102e847
May 16 02:42:36 beosrv1-t kernel: [3505746.348879]  000000000000dd08 ffff8806e77f5fd8 00000000000115c0 00000000000115c0
May 16 02:42:36 beosrv1-t kernel: [3505746.348907]  ffff8806554515c0 0000000000000005 ffff88024818ccd0 ffff880c3b9cc6b0
May 16 02:42:36 beosrv1-t kernel: [3505746.348935] Call Trace:
May 16 02:42:36 beosrv1-t kernel: [3505746.348952]  [<ffffffff8102e847>] ? enqueue_task_fair+0x16d/0x17a
May 16 02:42:36 beosrv1-t kernel: [3505746.348970]  [<ffffffff8102c6c4>] ? mutex_spin_on_owner+0x50/0x61
May 16 02:42:36 beosrv1-t kernel: [3505746.348991]  [<ffffffff813dd999>] __mutex_lock_slowpath+0xe9/0x133
May 16 02:42:36 beosrv1-t kernel: [3505746.349009]  [<ffffffff813dd81a>] mutex_lock+0x16/0x2d
May 16 02:42:36 beosrv1-t kernel: [3505746.349027]  [<ffffffff810a2175>] pipe_read+0x7d/0x3a8
May 16 02:42:36 beosrv1-t kernel: [3505746.349044]  [<ffffffff810a9850>] ? core_sys_select+0x200/0x254
May 16 02:42:36 beosrv1-t kernel: [3505746.349063]  [<ffffffff8109b03f>] do_sync_read+0xe7/0x12d
May 16 02:42:36 beosrv1-t kernel: [3505746.349080]  [<ffffffff81049a8f>] ? remove_wait_queue+0x48/0x4d
May 16 02:42:36 beosrv1-t kernel: [3505746.349098]  [<ffffffff8104fc7b>] ? ktime_get+0x65/0xc4
May 16 02:42:36 beosrv1-t kernel: [3505746.349129]  [<ffffffff81049828>] ? autoremove_wake_function+0x0/0x38
May 16 02:42:36 beosrv1-t kernel: [3505746.349164]  [<ffffffff810a87e0>] ? poll_select_copy_remaining+0xc5/0xea
May 16 02:42:36 beosrv1-t kernel: [3505746.349199]  [<ffffffff8109ba86>] vfs_read+0xab/0x147
May 16 02:42:36 beosrv1-t kernel: [3505746.349230]  [<ffffffff8109bbe6>] sys_read+0x47/0x6f
May 16 02:42:36 beosrv1-t kernel: [3505746.349261]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b

--------------090108070906030405080108
Content-Type: text/plain;
 name="kswapd.collectl"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kswapd.collectl"

#Time      PID  User     PR  PPID THRD S   VSZ   RSS CP  SysT  UsrT Pct  AccuTime MajF MinF Command
01:46:00    77  root     20     2    0 S     0     0  3  0.00  0.00   0 386:07.51    0    0 kswapd0
01:46:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.25    0    0 kswapd1
01:47:00    77  root     20     2    0 S     0     0  3  0.00  0.00   0 386:07.51    0    0 kswapd0
01:47:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.25    0    0 kswapd1
01:48:00    77  root     20     2    0 S     0     0  3  0.00  0.00   0 386:07.51    0    0 kswapd0
01:48:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.25    0    0 kswapd1
01:49:00    77  root     20     2    0 R     0     0  2 55.48  0.00  92 387:02.99    0    0 kswapd0
01:49:00    78  root     20     2    0 S     0     0  7  0.70  0.00   1 305:02.95    0    0 kswapd1
01:50:00    77  root     20     2    0 R     0     0  2 59.88  0.00  99 388:02.87    0    0 kswapd0
01:50:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:51:00    77  root     20     2    0 R     0     0  2 59.86  0.00  99 389:02.73    0    0 kswapd0
01:51:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:52:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 390:02.62    0    0 kswapd0
01:52:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:53:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 391:02.51    0    0 kswapd0
01:53:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:54:00    77  root     20     2    0 R     0     0  2 59.11  0.00  98 392:01.62    0    0 kswapd0
01:54:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:55:00    77  root     20     2    0 R     0     0  2 59.88  0.00  99 393:01.50    0    0 kswapd0
01:55:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:56:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 394:01.39    0    0 kswapd0
01:56:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:57:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 395:01.28    0    0 kswapd0
01:57:00    78  root     20     2    0 S     0     0  7  0.00  0.00   0 305:02.95    0    0 kswapd1
01:58:00    77  root     20     2    0 R     0     0  2 59.96  0.00  99 396:01.24    0    0 kswapd0
01:58:00    78  root     20     2    0 R     0     0  7 38.42  0.00  64 305:41.37    0    0 kswapd1
01:59:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 397:01.13    0    0 kswapd0
01:59:00    78  root     20     2    0 R     0     0  7 59.84  0.00  99 306:41.21    0    0 kswapd1
02:00:00    77  root     20     2    0 R     0     0  2 59.88  0.00  99 398:01.01    0    0 kswapd0
02:00:00    78  root     20     2    0 R     0     0  7 59.88  0.00  99 307:41.09    0    0 kswapd1
02:01:00    77  root     20     2    0 R     0     0  2 59.77  0.00  99 399:00.78    0    0 kswapd0
02:01:00    78  root     20     2    0 R     0     0  7 59.80  0.00  99 308:40.89    0    0 kswapd1
02:02:00    77  root     20     2    0 R     0     0  2 59.88  0.00  99 400:00.66    0    0 kswapd0
02:02:00    78  root     20     2    0 R     0     0  7 59.88  0.00  99 309:40.77    0    0 kswapd1
02:03:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 401:00.55    0    0 kswapd0
02:03:00    78  root     20     2    0 R     0     0  7 59.89  0.00  99 310:40.66    0    0 kswapd1
02:04:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 402:00.44    0    0 kswapd0
02:04:00    78  root     20     2    0 R     0     0  7 59.89  0.00  99 311:40.55    0    0 kswapd1
02:05:00    77  root     20     2    0 R     0     0  2 59.89  0.00  99 403:00.33    0    0 kswapd0
02:05:00    78  root     20     2    0 R     0     0  7 59.89  0.00  99 312:40.44    0    0 kswapd1
02:06:00    77  root     20     2    0 R     0     0  3 59.87  0.00  99 404:00.20    0    0 kswapd0
02:06:00    78  root     20     2    0 R     0     0  5 59.87  0.00  99 313:40.31    0    0 kswapd1
02:07:00    77  root     20     2    0 R     0     0  3 59.90  0.00  99 405:00.10    0    0 kswapd0
02:07:00    78  root     20     2    0 R     0     0  5 59.90  0.00  99 314:40.21    0    0 kswapd1

--------------090108070906030405080108--
