Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1ASOnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:43:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44075 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab1ASOnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GXh1UqggytMVhD7iB9OC8tKuc4EveWEkglbtbaEr5p/ldVRCcg0OdxuHy6MSW51meB
         /y19SQrEEtEEiHN+cAh4c/8wT9KrN0YK46U+cO8nr9RVhDEXs/k8sxp7OCy+MX04e45d
         us9QaEn2Vksp2OCQ0X+Zya+sf+zdsghP4i72A=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=ePSM7QTQgouAeP8xwLE0xFr3kW7iuBCqg8Wxb@mail.gmail.com>
References: <AANLkTi=_GSgFpsidp35-RDT3i6zhimXtyR=d6UtFmfMe@mail.gmail.com>
	<87ipxlj1vd.fsf@dmon-lp.sw.ru>
	<4D362DD2.8070606@gmail.com>
	<AANLkTi=ePSM7QTQgouAeP8xwLE0xFr3kW7iuBCqg8Wxb@mail.gmail.com>
Date: Wed, 19 Jan 2011 08:43:03 -0600
Message-ID: <AANLkTimh01GO1wxOWzYmPsyh0EuTCuxzr6+krNVTjRCP@mail.gmail.com>
Subject: Re: PROBLEM: Disk continually remounts and hardlocks the entire
 system if running on battery.
From: Robert Hancock <hancockrwd@gmail.com>
To: John Tyree <johntyree@gmail.com>
Cc: Dmitry <dmonakhov@openvz.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ide <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 5:43 AM, John Tyree <johntyree@gmail.com> wrote:
> Definitely doesn't happen on older kernels, just tested it again today.
> Unfortunately my last laptop did not have sata drives so I don't have
> another hdd to test with. There are other cases of this being reported
> though.
>
> http://groups.google.com/group/linux.kernel/browse_thread/thread/4e9ef24bc6f7151b/6d9d0dac67a0ae96?lnk=raot&pli=1

That doesn't look like the same thing - in their case it doesn't look
like any SATA errors are occurring, just a remount (presumably
triggered by some userspace software).

Maybe the remount that some software is doing is triggering something
funny? However, I'm not sure how the kernel could be triggering any
SError events, unless perhaps some software is also silently fiddling
with link power-saving modes or something?

You might want to try the power disconnect while running in
single-user mode with minimal processes running and see if the same
problem still occurs.

> I really don't think it's my hardware in this case. smartctl doesn't show
> anything failing either.
>
> John
>
> 2011/1/19 Robert Hancock <hancockrwd@gmail.com>
>>
>> (CCing linux-ide)
>>
>> On 01/18/2011 04:14 PM, Dmitry wrote:
>>>
>>> On Tue, 18 Jan 2011 22:46:34 +0100, John Tyree<johntyree@gmail.com>
>>>  wrote:
>>>>
>>>> [1.] Disk continually remounts and hardlocks the entire system if
>>>> running on
>>>> battery.
>>>>
>>>> [2.] When I unplug the power cord from laptop, the harddrive immediately
>>>> stops spinning and nothing happens for up to ten seconds or more. During
>>>> this
>>>> time, absolutely nothing works except the mouse moving around in X.
>>>> Applications do not redraw their guis, Can't launch anything or close
>>>> anything. Just have to wait until it remounts and I hear the drive spin
>>>> up.
>>>> At that time, everything snaps back to life as if nothing has happened.
>>>>
>>>> dmesg shows the following:
>>>
>>> oh, just look at ata errors, definitely this is not fs's problem,
>>> it's looks like your disk is dieing, Your options:
>>> 1) plug/unplug sata cable :), in my experience this is the root of cause
>>>    in 50% of cases.
>>> 2) smart ctl logs
>>>>
>>>> [28687.441335] ata1.00: configured for UDMA/33
>>>> [28687.441345] ata1: EH complete
>>>> [28687.443153] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
>>>> enabled,
>>>> doesn't support DPO or FUA
>>>> [28688.563053] EXT4-fs (sda5): re-mounted. Opts: commit=600
>>>> [28688.570501] EXT4-fs (dm-0): re-mounted. Opts: commit=600
>>>> [28727.760100] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x110000
>>>> action
>>>> 0x6 frozen
>>>> [28727.760115] ata1: SError: { PHYRdyChg Dispar }
>>>> [28727.760126] ata1.00: failed command: WRITE DMA EXT
>>>> [28727.760144] ata1.00: cmd 35/00:08:5d:8b:e1/00:00:17:00:00/e0 tag 0
>>>> dma
>>>> 4096 out
>>>> [28727.760148]          res 40/00:f4:00:00:00/00:00:00:00:00/40 Emask
>>>> 0x4
>>>> (timeout)
>>>> [28727.760156] ata1.00: status: { DRDY }
>>>> [28727.760170] ata1: hard resetting link
>>>> [28728.066096] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>>>> [28728.067819] ata1.00: configured for UDMA/33
>>>> [28728.068309] ata1.00: device reported invalid CHS sector 0
>>>> [28728.068337] ata1: EH complete
>>>> [28730.395512] ata1.00: configured for UDMA/33
>>>> [28730.395520] ata1: EH complete
>>>> [28730.430938] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
>>>> enabled,
>>>> doesn't support DPO or FUA
>>>> [28730.953631] EXT4-fs (sda5): re-mounted. Opts: commit=0
>>>> [28730.958914] EXT4-fs (dm-0): re-mounted. Opts: commit=0
>>>>
>>>> This happens everytime the power is unplugged and continutes to happen,
>>>> with
>>>> the harddrive spinning up and working for about 10 seconds before it
>>>> happens
>>>> again. When the power is plugged back in, everything goes right back to
>>>> normal. This started with vanilla 2.6.37 from linus's git. I thought it
>>>> might
>>>> have something to do with laptop-mode, but disabling it did not change
>>>> anything.
>>
>> Hmm, it seems like there's some kind of glitch happening on the SATA link.
>> In this case it looks like PHY ready change event(s) happened. I would tend
>> to suspect this being some kind of hardware problem. Are you sure this
>> doesn't occur on older kernels?
>
>
