Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1IUOpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1IUOpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:45:41 -0400
Message-ID: <4E79F88D.8000800@redhat.com>
Date: Wed, 21 Sep 2011 11:45:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: chris2553@googlemail.com
CC: Dave Young <hidave.darkstar@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org
Subject: Re: Oops in 2.6.37-rc{3,4,5}
References: <201012102234.06446.chris2553@googlemail.com> <20101212084504.GA27059@darkstar> <201012121115.02874.chris2553@googlemail.com>
In-Reply-To: <201012121115.02874.chris2553@googlemail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 12-12-2010 09:15, Chris Clayton escreveu:
> On Sunday 12 December 2010, Dave Young wrote:
>> On Fri, Dec 10, 2010 at 10:34:06PM +0000, Chris Clayton wrote:
>>> I'm not subscribed, so please cc me on any reply.
>>>
>>> With rc kernels from 2.6.37, X frequently (approx 3 boots out of every 4)
>>> fails to start. dmesg shows the oops below. I can bisect over the weekend
>>> - probably Sunday - if no answer comes up in the meantime. I get the same
>>> oops with rc3, rc and rc5. rc2 doesn't get as far as trying to start X.
>>> Happy to test patches or provide additional diagnostics, but I'll be off
>>> line soon until 20:00 or so UK time tomorrow.
> 
> <snip>
> 
>>>
>>> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>>> BUG: unable to handle kernel NULL pointer dereference at   (null)
>>> IP: [<c13229ef>] __mutex_lock_slowpath+0x9f/0x170
>>> *pdpt = 0000000034676001 *pde = 0000000000000000
>>> Oops: 0002 [#1] PREEMPT SMP
>>> last sysfs file: /sys/module/drm_kms_helper/initstate
>>> Modules linked in: i915 drm_kms_helper drm fb fbdev cfbcopyarea video
>>> backlight output cfbimgblt cfbfillrect xt_state iptable_filter
>>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
>>> nf_defrag_ipv4 saa7134_alsa tda10048 saa7134_dvb videobuf_dvb dvb_core
>>> mt20xx tea5767 tda9887 msp3400 gspca_zc3xx gspca_main tda18271 tda8290
>>> ir_lirc_codec tuner lirc_dev bttv i2c_algo_bit btcx_risc snd_bt87x
>>> ir_common uhci_hcd ir_core saa7134 v4l2_common videodev v4l1_compat
>>> ehci_hcd videobuf_dma_sg videobuf_core tveeprom evdev [last unloaded:
>>> floppy]
>>>
>>> Pid: 1725, comm: X Not tainted 2.6.37-rc5+ #476 EG41MF-US2H/EG41MF-US2H
>>> EIP: 0060:[<c13229ef>] EFLAGS: 00013246 CPU: 3
>>> EIP is at __mutex_lock_slowpath+0x9f/0x170
>>> EAX: 00000000 EBX: f4403410 ECX: f4403420 EDX: f4641dd8
>>> ESI: f4403414 EDI: 00000000 EBP: f4403418 ESP: f4641dd4
>>>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>>> Process X (pid: 1725, ti=f4640000 task=f3c67390 task.ti=f4640000)
>>> Stack:
>>>  f3c67390 f4403418 00000000 f46a3800 f4403410 f4fd14f0 f425f600 f4403400
>>>  c13228a6 f4fd1000 f4fd14f0 f8841b6c c10aabb2 ffffffff 05100004 f4c34000
>>>  f4df72c0 c10aabf7 f4403410 00000001 f425f600 ffffffed f425f604 f46bfe40
>>> Call Trace:
>>>  [<c13228a6>] ? mutex_lock+0x16/0x30
>>>  [<f8841b6c>] ? bttv_open+0xac/0x280 [bttv]
>>>  [<c10aabb2>] ? cdev_get+0x52/0x90
>>>  [<c10aabf7>] ? exact_lock+0x7/0x10
>>>  [<f87095a7>] ? v4l2_open+0xb7/0xd0 [videodev]
>>>  [<c10ab2ea>] ? chrdev_open+0xda/0x1b0
>>>  [<c10a5f25>] ? __dentry_open+0xd5/0x280
>>>  [<c10a7068>] ? nameidata_to_filp+0x68/0x70
>>>  [<c10ab210>] ? chrdev_open+0x0/0x1b0
>>>  [<c10b351f>] ? do_last.clone.32+0x34f/0x5a0
>>>  [<c10b3af3>] ? do_filp_open+0x383/0x550
>>>  [<c10b1e58>] ? getname+0x28/0xf0
>>>  [<c10a70c8>] ? do_sys_open+0x58/0x110
>>>  [<c10a5d09>] ? filp_close+0x49/0x70
>>>  [<c10a71ac>] ? sys_open+0x2c/0x40
>>>  [<c1002d10>] ? sysenter_do_call+0x12/0x26
>>>  [<c1320000>] ? timer_cpu_notify+0x1b4/0x233
>>> Code: 83 78 18 63 7f b6 8d b6 00 00 00 00 8d 73 04 8d 6b 08 89 f0 e8 f3
>>> 10 00 00 8b 43 0c 8d 54 24 04 89 44 24 08 89 53 0c 89 6c 24 04 <89> 10 8b
>>> 04 24 ba ff ff ff ff 89 44 24 0c 89 d0 87 03 83 f8 01
>>> EIP: [<c13229ef>] __mutex_lock_slowpath+0x9f/0x170 SS:ESP 0068:f4641dd4
>>> CR2: 0000000000000000
>>> ---[ end trace 5ac4e44ad0dc7959 ]---
> 
> <snip>
> 
>> Could you try following patch?
>>
>> --- linux-2.6.orig/drivers/media/video/bt8xx/bttv-driver.c	2010-11-27
>> 11:21:30.000000000 +0800 +++
>> linux-2.6/drivers/media/video/bt8xx/bttv-driver.c	2010-12-12
>> 16:31:39.633333338 +0800 @@ -3291,6 +3291,8 @@ static int bttv_open(struct
>> file *file)
>>  	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
>>  	if (unlikely(!fh))
>>  		return -ENOMEM;
>> +
>> +	mutex_init(&fh->cap.vb_lock);
>>  	file->private_data = fh;
>>
>>  	/*
> 
> Yes Dave, that's fixed it thanks. Six successful boots, which never happened 
> without the patch.
> 
> Tested-by: Chris Clayton <chris2553@googlemail.com>
> 

It seems we missed this patch. It looks right on my eyes, so I'm
applying it.

Thanks,
Mauro
