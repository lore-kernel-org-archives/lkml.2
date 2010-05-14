Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0ENGQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:16:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50493 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab0ENGQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=utxhgR/co/IarrvS2hVlSY/o8+Foa6dpUrucVy1hDKaDhNK0vGF3cTfzF3N9H2yyhM
         IH8OerPEpYoAJ/d69PLl+7DCbaXQsbP91Mr8dnAwPFxhHfzFx9Kk3PidJxwJfbYZnjVm
         QaAHepoiIanmbEMdAdS+WxYOed5iCfRNg6TRk=
MIME-Version: 1.0
In-Reply-To: <4BECD518.6040801@gmail.com>
References: <4BEC7A84.3010503@gmail.com> <201005141008.20667.br1@einfach.org> 
	<4BECA3AE.4070607@gmail.com> <20100514012314.GA2170@tux> <4BECA6AC.9060609@gmail.com> 
	<20100514014311.GC2170@tux> <20100514014553.GD2170@tux> <4BECB1F2.5050900@gmail.com> 
	<AANLkTilOJMtg1EIlDgY3_T5Xb6Zed0tbqkD7CGr7utol@mail.gmail.com> 
	<4BECD518.6040801@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 May 2010 23:16:22 -0700
X-Google-Sender-Auth: d-9r8lyF9FmFcaj5Ypii349DZkI
Message-ID: <AANLkTinE1q2K3j-IwCa3IPzTUChgi9wKTqBrVR1mGlv9@mail.gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Bruno Randolf <br1@einfach.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 9:44 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/13/10 21:01, Luis R. Rodriguez wrote:
>>
>> On Thu, May 13, 2010 at 7:14 PM, Justin P. Mattock
>> <justinmattock@gmail.com>  wrote:
>>
>>>
>>> what I can try, is(not at the convention, on eth0
>>> at the moment), but when I get back to the convention
>>> center place I can try your patch as well as the
>>> modprobe option, to see if I can get any signs of
>>> a recreation(if so I'll bisect there).
>>
>> The debug info I just need upon load of the module, I don't need you
>> to run the debug stuff to try to reproduce. The debug print upon load
>> will tell us the rxbuf size and cache line size.
>>
>>   Luis
>>
>
> o.k. it's not pretty due
> to loads of avc's for SELinux:
> (I run a rootless system).
>
> [   84.172649] ath9k: Driver unloaded
> [  100.675300] audit_printk_skb: 6 callbacks suppressed
> [  100.675306] type=1400 audit(1273811633.675:20): avc:  denied  { search }
> for  pid=2168 comm="modprobe" name="modules" dev=sda3 ino=2500
> scontext=name:staff_r:staff_sudo_t:s0
> tcontext=system_u:object_r:modules_object_t:s0 tclass=dir
> [  100.675408] type=1400 audit(1273811633.675:20): avc:  denied  { search }
> for  pid=2168 comm="modprobe" name="2.6.34-rc7-00057-gcdfda35" dev=sda3
> ino=524392 scontext=name:staff_r:staff_sudo_t:s0
> tcontext=name:object_r:modules_object_t:s0 tclass=dir
> [  100.675552] type=1400 audit(1273811633.675:20): avc:  denied  { read }
> for  pid=2168 comm="modprobe" name="modules.dep.bin" dev=sda3 ino=525251
> scontext=name:staff_r:staff_sudo_t:s0
> tcontext=name:object_r:modules_object_t:s0 tclass=file
> [  100.675598] type=1400 audit(1273811633.675:20): avc:  denied  { open }
> for  pid=2168 comm="modprobe" name="modules.dep.bin" dev=sda3 ino=525251
> scontext=name:staff_r:staff_sudo_t:s0
> tcontext=name:object_r:modules_object_t:s0 tclass=file
> [  100.675748] type=1300 audit(1273811633.675:20): arch=c000003e syscall=2
> success=yes exit=3 a0=60d140 a1=0 a2=1b6 a3=0 items=0 ppid=2080 pid=2168
> auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0
> ses=1 comm="modprobe" exe="/sbin/modprobe" subj=name:staff_r:staff_sudo_t:s0
> key=(null)
> [  100.675902] type=1400 audit(1273811633.675:21): avc:  denied  { getattr }
> for  pid=2168 comm="modprobe"
> path="/lib/modules/2.6.34-rc7-00057-gcdfda35/modules.dep.bin" dev=sda3
> ino=525251 scontext=name:staff_r:staff_sudo_t:s0
> tcontext=name:object_r:modules_object_t:s0 tclass=file
> [  100.676052] type=1300 audit(1273811633.675:21): arch=c000003e syscall=5
> success=yes exit=0 a0=3 a1=7fffd2d1dd70 a2=7fffd2d1dd70 a3=0 items=0
> ppid=2080 pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
> fsgid=0 tty=pts0 ses=1 comm="modprobe" exe="/sbin/modprobe"
> subj=name:staff_r:staff_sudo_t:s0 key=(null)
> [  100.698392] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
> 17
> [  100.698409] ath9k 0000:03:00.0: setting latency timer to 64
> [  100.828787] ath: EEPROM regdomain: 0x64
> [  100.828790] ath: EEPROM indicates we should expect a direct regpair map
> [  100.828793] ath: Country alpha2 being used: 00
> [  100.828795] ath: Regpair used: 0x64
> [  100.848609] type=1400 audit(1273811633.678:22): avc:  denied  { search }
> for  pid=2168 comm="modprobe" name="ieee80211" dev=debugfs ino=18
> scontext=name:staff_r:staff_sudo_t:s0
> tcontext=system_u:object_r:debugfs_t:s0 tclass=dir
> [  100.848788] phy1: Selected rate control algorithm 'ath9k_rate_control'
> [  100.850035] Registered led device: ath9k-phy1::radio
> [  100.850488] Registered led device: ath9k-phy1::assoc
> [  100.851227] Registered led device: ath9k-phy1::tx
> [  100.851633] Registered led device: ath9k-phy1::rx
> [  100.851640] phy1: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81
> mem=0xffffc900005a0000, irq=17
> [  100.852240] type=1300 audit(1273811633.678:22): arch=c000003e syscall=175
> success=yes exit=0 a0=7f1e9d6ab010 a1=19580 a2=60d920 a3=0 items=0 ppid=2080
> pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
> tty=pts0 ses=1 comm="modprobe" exe="/sbin/modprobe"
> subj=name:staff_r:staff_sudo_t:s0 key=(null)
>
> but there you go dmesg of the debug info for you

Justin, did you forget to use the debug parameter on modprobe ath9k?

modprobe ath9k debug=0x0000020

I do not see the output I expected.

  Luis
