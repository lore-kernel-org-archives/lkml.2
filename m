Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1DPSZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 14:25:34 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:59755 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1DPSZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 14:25:28 -0400
X-ASG-Debug-ID: 1302978324-01de284cf8157490001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA9DF15.80603@fusionio.com>
Date: Sat, 16 Apr 2011 20:25:25 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "maciej.rutecki@gmail.com" <maciej.rutecki@gmail.com>
CC: Shaun Ruffell <sruffell@digium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [2.6.39-rc2][bisected] Constant DISK_MEDIA_CHANGE_EVENTS from
  CDROM drive.
References: <20110408201513.GA3040@digium.com> <201104151913.38841.maciej.rutecki@gmail.com>
X-ASG-Orig-Subj: Re: [2.6.39-rc2][bisected] Constant DISK_MEDIA_CHANGE_EVENTS from
  CDROM drive.
In-Reply-To: <201104151913.38841.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302978324
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61045
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-15 19:13, Maciej Rutecki wrote:
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=33342
> for your bug report, please add your address to the CC list in there, thanks!
> 
> On piątek, 8 kwietnia 2011 o 22:15:13 Shaun Ruffell wrote:
>> Running with 2.6.39-rc2 on a CentOS 5.5 installation with a "IDE interface:
>> Intel Corporation 82801CA Ultra ATA Storage Controller (rev 02)"
>> (8086:248b), I've noticed constant DISK_MEDIA_CHANGE uevents.  In my
>> kernel log:
>>
>> [ 1107.530699] kobject: 'hda' (f5372610): fill_kobj_path: path =
>> '/block/hda' [ 1109.580559] kobject: 'hda' (f5372610): kobject_uevent_env
>> [ 1109.580594] kobject: 'hda' (f5372610): fill_kobj_path: path =
>> '/block/hda' [ 1111.630560] kobject: 'hda' (f5372610): kobject_uevent_env
>> [ 1111.630595] kobject: 'hda' (f5372610): fill_kobj_path: path =
>> '/block/hda' [ 1113.680560] kobject: 'hda' (f5372610): kobject_uevent_env
>>
>> And from udevmonitor --env:
>>
>> UEVENT[1302291995.789487] change@/block/hda
>> ACTION=change
>> DEVPATH=/block/hda
>> SUBSYSTEM=block
>> DISK_MEDIA_CHANGE=1
>> MAJOR=3
>> MINOR=0
>> DEVNAME=hda
>> DEVTYPE=disk
>> SEQNUM=1318
>>
>> I bisected it down to 929e27252e8ca69363f81f26af5eaba62cb4c572 'ide:
>> ide_requeue_and_plug() reinstate "always plug" behaviour'
>>
>> I haven't yet looked into how that change would result in the change in
>> behavior I'm seeing but I thought I would let you know sooner rather than
>> leter in case this is something that is already known.

Tejun, why would something like that trigger and endless stream of media
change events? I bet this is what is cauing ide-cd to hang the system as
well now. What I know:

- It only triggers on UP
- And then it only triggers when PREEMPT is completely turned off

-- 
Jens Axboe

