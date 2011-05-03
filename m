Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1ECJJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:09:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50606 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1ECJJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uG5cuxnU++ioi/oIVw+rOV61w7hLFW5Np/M2bsHMpmbG1Vld0y+FguwGECcHSy0OJP
         a5YH9BMqjvj4kzSpwS99EpnYFBnMcIuRIRgsRixcziMAP7RIuF6CXxtBPhlQyLZyAHC1
         gAyZil13SHv8qeORc54OeaDqVgCsSpSMvarY0=
MIME-Version: 1.0
In-Reply-To: <BANLkTinK7bDbwTvsWfxE8w6sPLC--1TUsQ@mail.gmail.com>
References: <4DBE5B8E.7010109@gmail.com>
	<BANLkTinK7bDbwTvsWfxE8w6sPLC--1TUsQ@mail.gmail.com>
Date: Tue, 3 May 2011 11:09:41 +0200
Message-ID: <BANLkTi=yeYsHN5pzW7WV5eskVqaC1m1FWw@mail.gmail.com>
Subject: Re: [bug] ASoC uda134x not working for me, and udev crashed at startup
From: Belisko Marek <marek.belisko@gmail.com>
To: microcai <microcaicai@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sound@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 9:56 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
> CC also linux-sound mailing list.
>
> On Mon, May 2, 2011 at 9:21 AM, microcai <microcaicai@gmail.com> wrote:
>> Heya,
>>
>> The commit a110f4ef810ee29d810876df725f41d66629733e is not working for
>> me. I'm using an TQ2440 platform, very similar to mini2440. Only the LCD
>> and LED is the difference. Basically just copy & past from the
>> mach-mini2440.c to mach-tq2440.c. ;)
>>
>> I installed Gentoo on the system, when startup, I got
>>
>> [    1.645000] ALSA device list:
>> [    1.645000]   No soundcards found.
> With this patch you shouldn't see this in boot log. At least it work for me ;)
Did you enable Audio in menuconfig? For mini2440_defconfig audio is not selected
by default. SoC I2S Audio support UDA134X wired to a S3C24XX must be enabled.
Please let us know if it helps.
>>
>>
>> And when systemd starts udevadm, I got Unable to handle kernel paging
>> request, complet list append.
>>
>> Please CC me if any one knows anything about it, or need more
>> information. I'll be glad to provide help.
>>
>>
>> [   20.455000] ------------[ cut here ]------------
>> [   20.455000] WARNING: at fs/sysfs/file.c:355 sysfs_open_file+0xa4/0x268()
>> [   20.460000] Unable to handle kernel paging request at virtual address
>> 706f720
>> [   20.460000] pgd = 82c70000
>>
>> [   20.460000] [706f7270] *pgd=00000000
>> [   20.460000] Internal error: Oops: 5 [#1]
>> [   20.460000] last sysfs file: /sys/devices/platform/uda134x-codec.0/uevent
>> [   20.460000] Modules linked in:
>> [   20.460000] CPU: 0    Not tainted  (2.6.38.4+ #175)
>> [   20.460000] PC is at strnlen+0x1c/0x34
>> [   20.460000] LR is at string.clone.1+0x34/0xd4
>> [   20.460000] pc : [<801664cc>]    lr : [<80167bd4>]    psr: a0000093
>> [   20.460000] sp : 82c27c80  ip : 82c27c90  fp : 82c27c8c
>> [   20.460000] r10: 8055c569  r9 : 00000002  r8 : 706f7270
>> [   20.460000] r7 : 00000000  r6 : ffffffff  r5 : 805cb1dc  r4 : 805cae0f
>> [   20.460000] r3 : 706f7270  r2 : 706f7270  r1 : ffffffff  r0 : 706f7270
>> [   20.460000] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
>> Segment usr
>> [   20.460000] Control: c000717f  Table: 32c70000  DAC: 00000015
>> [   20.460000] Process udevadm (pid: 457, stack limit = 0x82c26270)
>> [   20.460000] Stack: (0x82c27c80 to 0x82c28000)
>> [   20.460000] 7c80: 82c27cb4 82c27c90 80167bd4 801664c0 00000000
>> 82c27dec 805cb
>> [   20.460000] 7ca0: 805caddc 805cae0f 82c27d04 82c27cb8 80168a70
>> 80167bb0 fffff
>> [   20.460000] 7cc0: 00000052 805a922c 805cae1d 00000400 ff0a0004
>> ffffffff 82c20
>> [   20.460000] 7ce0: 805cad30 805caddc 00000004 8055c536 82c26000
>> 82c27dec 82c28
>> [   20.460000] 7d00: 80168cd4 801688a0 82c27dec 00000000 82c27d9c
>> 82c27d20 80030
>> [   20.460000] 7d20: 00205d30 82c27d30 80165624 8380d8c0 82c27dc4
>> 60000013 80023
>> [   20.460000] 7d40: 00000000 800aab30 82c27d94 82c27dd0 00000163
>> 8055c526 800e9
>> [   20.460000] 7d60: 82c26000 00000000 82c27d8c 82c27d78 802b3a88
>> 82c27dd0 00006
>> [   20.460000] 7d80: 800e0170 00000009 82c26000 00000000 82c27dc4
>> 82c27da0 80038
>> [   20.460000] 7da0: 00000009 838525d0 83471130 82d0c800 805f1a33
>> 800206e0 82c28
>> [   20.460000] 7dc0: 8003a810 8003a714 82c27dd0 8380d6e0 8055c536
>> 82c27dec 82c20
>> [   20.460000] 7de0: 800e0170 8003a7ec 8055c536 706f7270 802bcfc0
>> 8380d8c0 83470
>> [   20.460000] 7e00: 83471130 800e00cc 82c26000 00000000 82c27e44
>> 82c27e20 8009c
>> [   20.460000] 7e20: 00000000 82d0c800 82c27ebc 00020001 00000022
>> ffffff9c 82c28
>> [   20.460000] 7e40: 80098d6c 80097d80 00008000 82c27ebc 00000000
>> 00000000 82c28
>> [   20.460000] 7e60: 800a4f88 80098d3c 800a4934 800a1f24 00020001
>> 00020001 0000c
>> [   20.460000] 7e80: 00000000 00000022 82c27f5c 82c27e98 800a5420
>> 800a4f0c 80680
>> [   20.460000] 7ea0: 00000003 00000000 82c27ee4 00000000 ffffff9c
>> 83b91000 00000
>> [   20.460000] 7ec0: 83470180 00000000 82c27ef4 82c27ed8 00000000
>> 83410b80 00000
>> [   20.460000] 7ee0: 00000101 00000002 00000001 00000000 800765f4
>> 80076420 805f0
>> [   20.460000] 7f00: 82c27f1c 82c27f10 82c2eb40 8346fd10 000007c0
>> 00020002 00000
>> [   20.460000] 7f20: 00020001 00000003 82c27f5c 82c27f38 800af2e4
>> 00000003 00020
>> [   20.460000] 7f40: 00000000 00000000 82c26000 ffffff9c 82c27f94
>> 82c27f60 8009c
>> [   20.460000] 7f60: 00000000 82c27f70 80097c60 7ecbf4b0 7ecbf4b0
>> 7ecbffa1 00008
>> [   20.460000] 7f80: 82c26000 00000000 82c27fa4 82c27f98 80098e94
>> 80098d88 00008
>> [   20.460000] 7fa0: 80024fe0 80098e7c 7ecbf4b0 7ecbf4b0 7ecbf4b0
>> 00020001 00000
>> [   20.460000] 7fc0: 7ecbf4b0 7ecbf4b0 7ecbffa1 00000005 00000000
>> 00021fc4 0002f
>> [   20.460000] 7fe0: 0002c104 7ecbf478 00015334 2ac4150c 60000010
>> 7ecbf4b0 33ff1
>> [   20.460000] Backtrace:
>> [   20.460000] [<801664b0>] (strnlen+0x0/0x34) from [<80167bd4>]
>> (string.clone.)
>> [   20.460000] [<80167ba0>] (string.clone.1+0x0/0xd4) from [<80168a70>]
>> (vsnpri)
>> [   20.460000]  r8:805cae0f r7:805caddc r6:8055c56b r5:805cb1dc r4:82c27dec
>> [   20.460000] r3:00000000
>> [   20.460000] [<80168890>] (vsnprintf+0x0/0x3b0) from [<80168cd4>]
>> (vscnprintf)
>> [   20.460000] [<80168cc0>] (vscnprintf+0x0/0x2c) from [<8003b70c>]
>> (vprintk+0x)
>> [   20.460000]  r4:00000000 r3:82c27dec
>>
>> [   20.460000] [<8003b5d8>] (vprintk+0x0/0x35c) from [<8003a74c>]
>> (warn_slowpat)
>> [   20.460000] [<8003a704>] (warn_slowpath_common+0x0/0x68) from
>> [<8003a810>] ()
>> [   20.460000]  r8:800206e0 r7:805f1a33 r6:82d0c800 r5:83471130
>> r4:838525d0
>> [   20.460000] r3:00000009
>>
>> [   20.460000] [<8003a7d8>] (warn_slowpath_fmt+0x0/0x40) from
>> [<800e0170>] (sys)
>> [   20.460000]  r3:706f7270 r2:8055c536
>> [   20.460000] [<800e00cc>] (sysfs_open_file+0x0/0x268) from
>> [<80097e9c>] (__de)
>> [   20.460000] [<80097d70>] (__dentry_open.clone.16+0x0/0x220) from
>> [<80098d6c>)
>> [   20.460000] [<80098d2c>] (nameidata_to_filp+0x0/0x4c) from
>> [<800a4f88>] (fin)
>> [   20.460000]  r6:00000000 r5:00000000 r4:82c27ebc r3:00008000
>> [   20.460000] [<800a4efc>] (finish_open+0x0/0x16c) from [<800a5420>]
>> (do_filp_)
>> [   20.460000]  r8:00000022 r7:00000000 r6:82c27ebc r5:00000101
>> r4:00020001
>> [   20.460000] [<800a52fc>] (do_filp_open+0x0/0x4ec) from [<80098ddc>]
>> (do_sys_)
>> [   20.460000] [<80098d78>] (do_sys_open+0x0/0xf4) from [<80098e94>]
>> (sys_open+)
>> [   20.460000] [<80098e6c>] (sys_open+0x0/0x2c) from [<80024fe0>]
>> (ret_fast_sys)
>> [   20.460000] Code: e1a03000 e3510000 e1a02003 0a000003 (e4d3c001)
>> [   20.465000] ---[ end trace e209d36fad2471ab ]---
>> [   20.900000] <29>systemd[1]: udev-trigger.service: main process
>> exited, code=1
>> [   21.000000] <29>systemd[1]: Unit udev-trigger.service entered failed
>> state.
>>
>>
>>
>>
>>
>>
>>
>
> regards,
>
> marek
>
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
>
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> icq: 290551086
> web: http://open-nandra.com
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
