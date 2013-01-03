Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3ACSPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:15:47 -0500
Received: from server505e.appriver.com ([98.129.35.9]:1216 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752998Ab3ACSPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:15:44 -0500
X-Note-AR-ScanTimeLocal: 1/3/2013 12:15:40 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Josh Boyer <jwboyer@redhat.com>,
        "mitko@banksoft-bg.com" <mitko@banksoft-bg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fedoraproject.org" <kernel-team@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 3 Jan 2013 12:15:35 -0600
Subject: Re: Oops on aoe module removal
Thread-Topic: Oops on aoe module removal
Thread-Index: Ac3p3lPI2HpuaaJbTUyrPxh+zszZ4w==
Message-ID: <32456405-00CA-43EC-A17A-28452C217A7F@coraid.com>
References: <20130103132556.GA13290@hansolo.jdub.homelinux.org>
 <587E85C3-7395-4BC1-B31B-426572B5080C@coraid.com>
 <50E5910E.7060606@kernel.dk> <50E591CD.40802@kernel.dk>
 <D2D8353E-8DE1-44A2-BB7F-3FE1E2E794FB@coraid.com>
 <50E5A51C.3030800@kernel.dk>
In-Reply-To: <50E5A51C.3030800@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2013, at 10:34 AM, Jens Axboe wrote:

> On 2013-01-03 16:28, Ed Cashin wrote:
>> On Jan 3, 2013, at 9:12 AM, Jens Axboe wrote:
>> 
>>> On 2013-01-03 15:09, Jens Axboe wrote:
>>>> On 2013-01-03 15:02, Ed Cashin wrote:
>>>>> On Jan 3, 2013, at 8:25 AM, Josh Boyer wrote:
>>>>> 
>>>>>> Hello,
>>>>>> 
>>>>>> We have a user that has reported an oops when removing the aoe module.
>>>>>> This seems to have been happening since the 3.4 kernel, as you can see
>>>>>> in this bug: https://bugzilla.redhat.com/show_bug.cgi?id=853064
>>>>>> 
>>>>>> The recreate steps and oops output from a 3.6.11 kernel is below.  Any
>>>>>> thoughts on what could be causing this?
>>>>>> 
>>>>>> josh
>>>>>> 
>>>>>> 
>>>>>> I run the following commands sequentially
>>>>>> 
>>>>>> - modprobe aoe
>>>>>> - dmesg:
>>>>>> [699170.611997] aoe: AoE v47 initialised.
>>>>>> [699170.653980] aoe: e4.1: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654106] aoe: e6.0: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654961] aoe: e6.2: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654961] aoe: e6.3: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654961] aoe: e8.1: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654961] aoe: e8.2: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654961] aoe: e8.10: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654961] aoe: e8.11: setting 8192 byte data frames on eth1:000423d36ac3
>>>>>> [699170.654961] aoe: 000423d36ac3 e4.1 v0100 has 33554432 sectors
>>>>>> [699170.654961] aoe: 000423d36ac3 e6.0 v0100 has 12582912 sectors
>>>>>> [699170.654961] aoe: 000423d36ac3 e6.2 v0100 has 16777216 sectors
>>>>>> [699170.702143] aoe: 000423d36ac3 e6.3 v0100 has 104857600 sectors
>>>>>> [699170.706391] aoe: 000423d36ac3 e8.1 v0100 has 272629760 sectors
>>>>>> [699170.710623] aoe: 000423d36ac3 e8.2 v0100 has 67108864 sectors
>>>>>> [699170.714851] aoe: 000423d36ac3 e8.10 v0100 has 33554432 sectors
>>>>>> [699170.719056] aoe: 000423d36ac3 e8.11 v0100 has 67108864 sectors
>>>>>> [699170.824774]  etherd/e4.1: p1
>>>>>> [699170.829069]  etherd/e6.0: p1 p2
>>>>>> [699170.833274]  etherd/e8.1: p1 p2
>>>>>> [699170.837329]  etherd/e8.2: p1
>>>>>> [699170.841204]  etherd/e8.10: p1
>>>>>> [699170.845030]  etherd/e8.11: p1
>>>>>> [699170.848706]  etherd/e6.3: unknown partition table
>>>>>> [699170.852384]  etherd/e6.2: unknown partition table
>>>>>> 
>>>>>> - lsmod |grep aoe
>>>>>> aoe                    32214  0	  
>>>>>> 
>>>>>> - modprobe -vr aoe
>>>>>> - dmesg:
>>>>>> [699231.304689] ------------[ cut here ]------------
>>>>>> [699231.308319] WARNING: at lib/list_debug.c:62 __list_del_entry+0x82/0xd0()
>>>>>> [699231.312031] Hardware name: S5000VSA
>>>>>> [699231.315658] list_del corruption. next->prev should be ffff880009fa37e8, but was ffffffff81c79c00
>>>>>> [699231.319352] Modules linked in: aoe(-) ip6table_filter ip6_tables ebtable_nat ebtables lockd sunrpc bridge 8021q garp stp llc vfat fat binfmt_misc iTCO_wdt iTCO_vendor_support vhost_net lpc_ich radeon tun macvtap mfd_core serio_raw coretemp i2c_algo_bit ttm i5000_edac macvlan drm_kms_helper e1000e edac_core microcode i5k_amb shpchp i2c_i801 drm kvm_intel i2c_core kvm ioatdma dca raid1
>>>>>> [699231.336259] Pid: 8584, comm: modprobe Not tainted 3.6.11-1.fc17.x86_64 #1
>>>>>> [699231.340561] Call Trace:
>>>>>> [699231.344865]  [<ffffffff8105c8ef>] warn_slowpath_common+0x7f/0xc0
>>>>>> [699231.349212]  [<ffffffff8105c9e6>] warn_slowpath_fmt+0x46/0x50
>>>>>> [699231.353595]  [<ffffffff812eee52>] __list_del_entry+0x82/0xd0
>>>>>> [699231.357954]  [<ffffffff812eeeb1>] list_del+0x11/0x40
>>>>>> [699231.362319]  [<ffffffff812f6458>] percpu_counter_destroy+0x28/0x50
>>>>>> [699231.366712]  [<ffffffff8114c513>] bdi_destroy+0x43/0x140
>>>>>> [699231.371127]  [<ffffffff812be20c>] blk_release_queue+0x8c/0xc0
>>>>>> [699231.375454]  [<ffffffff812dc322>] kobject_cleanup+0x82/0x1b0
>>>>>> [699231.379675]  [<ffffffff812dc1ab>] kobject_put+0x2b/0x60
>>>>>> [699231.383851]  [<ffffffff812b80a5>] blk_put_queue+0x15/0x20
>>>>>> [699231.387899]  [<ffffffff812bc659>] blk_cleanup_queue+0xc9/0xe0
>>>>>> [699231.391794]  [<ffffffffa01f53f5>] aoedev_freedev+0x135/0x150 [aoe]
>>>>>> [699231.395668]  [<ffffffffa01f59a5>] aoedev_exit+0x65/0x80 [aoe]
>>>>>> [699231.399493]  [<ffffffffa01f5afe>] aoe_exit+0x2e/0x40 [aoe]
>>>>>> [699231.403273]  [<ffffffff810bdefe>] sys_delete_module+0x16e/0x2d0
>>>>>> [699231.407119]  [<ffffffff8161db56>] ? __schedule+0x3c6/0x7a0
>>>>>> [699231.411050]  [<ffffffff8119054a>] ? sys_write+0x4a/0x90
>>>>>> [699231.415033]  [<ffffffff81627329>] system_call_fastpath+0x16/0x1b
>>>>>> [699231.419117] ---[ end trace 9e1558af1964b569 ]---
>>>>>> [699231.423248] ------------[ cut here ]------------
>>>>> 
>>>>> Thanks for the report.  The problem seems to be older than that (see
>>>>> 2.6.32 below), and it seems to be related to changes that first
>>>>> appeared in 2.6.24.  I'm going to investigate the changes introduced
>>>>> in the commit below to see whether the aoe driver needed updating when
>>>>> they went in.  I'm Cc-ing Peter Zijlstra in case this rings any bells.
>>>> 
>>>> I highly doubt that has anything to do with it. Since it triggers
>>>> immediately on rmmod after modprobe (and not having set a device up,
>>>> presumably, being the key), it looks like a generic bug in aoeblk.
>>>> 
>>>> Ed, can you reproduce the issue?
>>> 
>>> Quick guess...
>>> 
>>> 
>>> diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
>>> index 98f2965..e4473af 100644
>>> --- a/drivers/block/aoe/aoedev.c
>>> +++ b/drivers/block/aoe/aoedev.c
>>> @@ -280,8 +280,8 @@ freedev(struct aoedev *d)
>>> 	if (d->gd) {
>>> 		aoedisk_rm_sysfs(d);
>>> 		del_gendisk(d->gd);
>>> -		put_disk(d->gd);
>>> 		blk_cleanup_queue(d->blkq);
>>> +		put_disk(d->gd);
>>> 	}
>>> 	t = d->targets;
>>> 	e = t + d->ntargets;
>> 
>> Yes, I can reproduce it on 3.5.6.  There are devices up, none down,
>> when I do rmmod.  If no aoe devices are present, the warnings do not
>> appear.
> 
> OK, that's good at least. I can try here too.
> 
>> The suggestion above to move put_disk after blk_cleanup_queue doesn't
>> affect the list_del warnings, but thanks for the quick guess---Is that
>> something we need to change regardless of the issue at hand?
> 
> No should not matter.

Argh.  I tried to send the email in a hurry and vger rejected the message as spam because of the HTML subpart.  I'll get a process set up for sending replies as clean emails.  Meanwhile, my message said,

"Thanks.  I think I see the problem.  The blk_alloc_queue has already done a bdi_init, and there's no need for aoeblk.c to do it, so when it does, the bdi_stat lists get messed up.

If you think that makes sense and the patch below (corrupted by our MS Exchange email server) also makes sense as a proof of concept, I'll send akpm a proper patch without email corruption.  The patch below eliminates the list_del corruption messages in my tests, and I think the mainline aoe driver needs (the cleaned up version of) it as well as older stable kernels."

... and the patch just ifdeffed out the call to bdi_init in aoeblk.c:aoeblk_gdalloc(), along with the associated error handling.

-- 
  Ed Cashin
  ecashin@coraid.com


