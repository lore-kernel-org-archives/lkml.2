Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0ENRZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:25:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43073 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0ENRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t8EPQJnGPrSA8OpblGmO/UOyDgGX6bEgv0l4CRvzM569EVqTlZagdjVj9x+tD0ogYb
         3kQRe+Nez8GKonlMD5wPmB9Pz5zzRYniUb+56BnCS9LC10aVJVUxhcNrYSlq3Aww3tpK
         5EAlXdeR0ZDhPlvI6cleGUNZWMNZP/GmY7dWQ=
Message-ID: <4BED8765.8040307@gmail.com>
Date: Fri, 14 May 2010 10:24:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bruno Randolf <br1@einfach.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
References: <4BEC7A84.3010503@gmail.com> <201005141520.30802.br1@einfach.org> <4BECEE3E.6090303@gmail.com> <201005141538.43416.br1@einfach.org> <4BED6F19.3040608@gmail.com> <20100514165325.GA28198@tux>
In-Reply-To: <20100514165325.GA28198@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/10 09:53, Luis R. Rodriguez wrote:
> On Fri, May 14, 2010 at 08:41:13AM -0700, Justin P. Mattock wrote:
>> On 05/13/10 23:38, Bruno Randolf wrote:
>>> On Friday 14 May 2010 15:31:26 Justin P. Mattock wrote:
>>>> On 05/13/10 23:20, Bruno Randolf wrote:
>>>>> On Friday 14 May 2010 15:16:22 Luis R. Rodriguez wrote:
>>>>>> On Thu, May 13, 2010 at 9:44 PM, Justin P. Mattock
>>>>>>
>>>>>> <justinmattock@gmail.com>    wrote:
>>>>>>> On 05/13/10 21:01, Luis R. Rodriguez wrote:
>>>>>>>> On Thu, May 13, 2010 at 7:14 PM, Justin P. Mattock
>>>>>>>>
>>>>>>>> <justinmattock@gmail.com>     wrote:
>>>>>>>>> what I can try, is(not at the convention, on eth0
>>>>>>>>> at the moment), but when I get back to the convention
>>>>>>>>> center place I can try your patch as well as the
>>>>>>>>> modprobe option, to see if I can get any signs of
>>>>>>>>> a recreation(if so I'll bisect there).
>>>>>>>>
>>>>>>>> The debug info I just need upon load of the module, I don't need you
>>>>>>>> to run the debug stuff to try to reproduce. The debug print upon load
>>>>>>>> will tell us the rxbuf size and cache line size.
>>>>>>>>
>>>>>>>>      Luis
>>>>>>>
>>>>>>> o.k. it's not pretty due
>>>>>>> to loads of avc's for SELinux:
>>>>>>> (I run a rootless system).
>>>>>>>
>>>>>>> [   84.172649] ath9k: Driver unloaded
>>>>>>> [  100.675300] audit_printk_skb: 6 callbacks suppressed
>>>>>>> [  100.675306] type=1400 audit(1273811633.675:20): avc:  denied  {
>>>>>>> search } for  pid=2168 comm="modprobe" name="modules" dev=sda3
>>>>>>> ino=2500 scontext=name:staff_r:staff_sudo_t:s0
>>>>>>> tcontext=system_u:object_r:modules_object_t:s0 tclass=dir
>>>>>>> [  100.675408] type=1400 audit(1273811633.675:20): avc:  denied  {
>>>>>>> search } for  pid=2168 comm="modprobe"
>>>>>>> name="2.6.34-rc7-00057-gcdfda35" dev=sda3 ino=524392
>>>>>>> scontext=name:staff_r:staff_sudo_t:s0
>>>>>>> tcontext=name:object_r:modules_object_t:s0 tclass=dir
>>>>>>> [  100.675552] type=1400 audit(1273811633.675:20): avc:  denied  { read
>>>>>>> } for  pid=2168 comm="modprobe" name="modules.dep.bin" dev=sda3
>>>>>>> ino=525251 scontext=name:staff_r:staff_sudo_t:s0
>>>>>>> tcontext=name:object_r:modules_object_t:s0 tclass=file
>>>>>>> [  100.675598] type=1400 audit(1273811633.675:20): avc:  denied  { open
>>>>>>> } for  pid=2168 comm="modprobe" name="modules.dep.bin" dev=sda3
>>>>>>> ino=525251 scontext=name:staff_r:staff_sudo_t:s0
>>>>>>> tcontext=name:object_r:modules_object_t:s0 tclass=file
>>>>>>> [  100.675748] type=1300 audit(1273811633.675:20): arch=c000003e
>>>>>>> syscall=2 success=yes exit=3 a0=60d140 a1=0 a2=1b6 a3=0 items=0
>>>>>>> ppid=2080 pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0
>>>>>>> sgid=0 fsgid=0 tty=pts0 ses=1 comm="modprobe" exe="/sbin/modprobe"
>>>>>>> subj=name:staff_r:staff_sudo_t:s0 key=(null)
>>>>>>> [  100.675902] type=1400 audit(1273811633.675:21): avc:  denied  {
>>>>>>> getattr } for  pid=2168 comm="modprobe"
>>>>>>> path="/lib/modules/2.6.34-rc7-00057-gcdfda35/modules.dep.bin" dev=sda3
>>>>>>> ino=525251 scontext=name:staff_r:staff_sudo_t:s0
>>>>>>> tcontext=name:object_r:modules_object_t:s0 tclass=file
>>>>>>> [  100.676052] type=1300 audit(1273811633.675:21): arch=c000003e
>>>>>>> syscall=5 success=yes exit=0 a0=3 a1=7fffd2d1dd70 a2=7fffd2d1dd70 a3=0
>>>>>>> items=0 ppid=2080 pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
>>>>>>> egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="modprobe"
>>>>>>> exe="/sbin/modprobe"
>>>>>>> subj=name:staff_r:staff_sudo_t:s0 key=(null)
>>>>>>> [  100.698392] ath9k 0000:03:00.0: PCI INT A ->    GSI 17 (level, low) ->
>>>>>>> IRQ 17
>>>>>>> [  100.698409] ath9k 0000:03:00.0: setting latency timer to 64
>>>>>>> [  100.828787] ath: EEPROM regdomain: 0x64
>>>>>>> [  100.828790] ath: EEPROM indicates we should expect a direct regpair
>>>>>>> map [  100.828793] ath: Country alpha2 being used: 00
>>>>>>> [  100.828795] ath: Regpair used: 0x64
>>>>>>> [  100.848609] type=1400 audit(1273811633.678:22): avc:  denied  {
>>>>>>> search } for  pid=2168 comm="modprobe" name="ieee80211" dev=debugfs
>>>>>>> ino=18 scontext=name:staff_r:staff_sudo_t:s0
>>>>>>> tcontext=system_u:object_r:debugfs_t:s0 tclass=dir
>>>>>>> [  100.848788] phy1: Selected rate control algorithm
>>>>>>> 'ath9k_rate_control' [  100.850035] Registered led device:
>>>>>>> ath9k-phy1::radio
>>>>>>> [  100.850488] Registered led device: ath9k-phy1::assoc
>>>>>>> [  100.851227] Registered led device: ath9k-phy1::tx
>>>>>>> [  100.851633] Registered led device: ath9k-phy1::rx
>>>>>>> [  100.851640] phy1: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81
>>>>>>> mem=0xffffc900005a0000, irq=17
>>>>>>> [  100.852240] type=1300 audit(1273811633.678:22): arch=c000003e
>>>>>>> syscall=175 success=yes exit=0 a0=7f1e9d6ab010 a1=19580 a2=60d920 a3=0
>>>>>>> items=0 ppid=2080 pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
>>>>>>> egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="modprobe"
>>>>>>> exe="/sbin/modprobe"
>>>>>>> subj=name:staff_r:staff_sudo_t:s0 key=(null)
>>>>>>>
>>>>>>> but there you go dmesg of the debug info for you
>>>>>>
>>>>>> Justin, did you forget to use the debug parameter on modprobe ath9k?
>>>>>>
>>>>>> modprobe ath9k debug=0x0000020
>>>>>>
>>>>>> I do not see the output I expected.
>>>>>
>>>>> i think you have to do at least "ifconfig wlan0 up" to see it - (at least
>>>>> for ath5k).
>>>>>
>>>>> bruno
>>>>
>>>> didn't think todo so, I'll redu
>>>> again and see. BTW: the connection
>>>> over here is dodgy(hotel) should I at-least
>>>> find a stable access point? i.g. convetion
>>>> center seemed semi somewhat there
>>>
>>> no that does not matter. just ifconfig up is enough. it's just initialization,
>>> you don't need a connection for that.
>>>
>>> bruno
>>>
>>>> Justin P. Mattock
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>>> in the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> here you go:
>> (hopefully I did this correct)
>>
>> [   84.172542] ath9k 0000:03:00.0: PCI INT A disabled
>> [   84.172649] ath9k: Driver unloaded
>> [  100.675300] audit_printk_skb: 6 callbacks suppressed
>> [  100.675306] type=1400 audit(1273811633.675:20): avc:  denied  {
>> search } for  pid=2168 comm="modprobe" name="modules" dev=sda3 ino=2500
>>         xt=name:staff_r:staff_sudo_t:s0
>> tcontext=system_u:object_r:modules_object_t:s0 tclass=dir
>> [  100.675408] type=1400 audit(1273811633.675:20): avc:  denied  {
>> search } for  pid=2168 comm="modprobe" name="2.6.34-rc7-00057-gcdfda35"
>> dev=sda3 ino=524392 scontext=name:staff_r:staff_sudo_t:s0
>> tcontext=name:object_r:modules_object_t:s0 tclass=dir
>> [  100.675552] type=1400 audit(1273811633.675:20): avc:  denied  { read
>> } for  pid=2168 comm="modprobe" name="modules.dep.bin" dev=sda3
>> ino=525251 scontext=name:staff_r:staff_sudo_t:s0
>> tcontext=name:object_r:modules_object_t:s0 tclass=file
>> [  100.675598] type=1400 audit(1273811633.675:20): avc:  denied  { open
>> } for  pid=2168 comm="modprobe" name="modules.dep.bin" dev=sda3
>> ino=525251 scontext=name:staff_r:staff_sudo_t:s0
>> tcontext=name:object_r:modules_object_t:s0 tclass=file
>> [  100.675748] type=1300 audit(1273811633.675:20): arch=c000003e
>> syscall=2 success=yes exit=3 a0=60d140 a1=0 a2=1b6 a3=0 items=0
>> ppid=2080 pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0
>> sgid=0 fsgid=0 tty=pts0 ses=1 comm="modprobe" exe="/sbin/modprobe"
>> subj=name:staff_r:staff_sudo_t:s0 key=(null)
>> [  100.675902] type=1400 audit(1273811633.675:21): avc:  denied  {
>> getattr } for  pid=2168 comm="modprobe"
>> path="/lib/modules/2.6.34-rc7-00057-gcdfda35/modules.dep.bin" dev=sda3
>> ino=525251 scontext=name:staff_r:staff_sudo_t:s0
>> tcontext=name:object_r:modules_object_t:s0 tclass=file
>> [  100.676052] type=1300 audit(1273811633.675:21): arch=c000003e
>> syscall=5 success=yes exit=0 a0=3 a1=7fffd2d1dd70 a2=7fffd2d1dd70 a3=0
>> items=0 ppid=2080 pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
>> egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="modprobe"
>> exe="/sbin/modprobe" subj=name:staff_r:staff_sudo_t:s0 key=(null)
>> [  100.698392] ath9k 0000:03:00.0: PCI INT A ->  GSI 17 (level, low) ->
>> IRQ 17
>> [  100.698409] ath9k 0000:03:00.0: setting latency timer to 64
>> [  100.828787] ath: EEPROM regdomain: 0x64
>> [  100.828790] ath: EEPROM indicates we should expect a direct regpair map
>> [  100.828793] ath: Country alpha2 being used: 00
>> [  100.828795] ath: Regpair used: 0x64
>>
>> [  100.848609] type=1400 audit(1273811633.678:22): avc:  denied  {
>> search } for  pid=2168 comm="modprobe" name="ieee80211" dev=debugfs
>> ino=18 scontext=name:staff_r:staff_sudo_t:s0
>> tcontext=system_u:object_r:debugfs_t:s0 tclass=dir
>> [  100.848788] phy1: Selected rate control algorithm 'ath9k_rate_control'
>> [  100.850035] Registered led device: ath9k-phy1::radio
>> [  100.850488] Registered led device: ath9k-phy1::assoc
>> [  100.851227] Registered led device: ath9k-phy1::tx
>> [  100.851633] Registered led device: ath9k-phy1::rx
>> [  100.851640] phy1: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81
>> mem=0xffffc900005a0000, irq=17
>> [  100.852240] type=1300 audit(1273811633.678:22): arch=c000003e
>> syscall=175 success=yes exit=0 a0=7f1e9d6ab010 a1=19580 a2=60d920 a3=0
>> items=0 ppid=2080 pid=2168 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
>> egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="modprobe"
>> exe="/sbin/modprobe" subj=name:staff_r:staff_sudo_t:s0 key=(null)
>>
>>
>> let me know if you need more info.. I'll be off the grid in
>> a few, then probably wont be back on till a while
>> (since I aint got's no 99 big ones for intranet!!)
>
> Your output still did not have the stuff I was looking for, just do:
>
> dmesg | grep cachelsz
>
> If nothing comes up it doesn't have the output I was looking for yet.
>
>    Luis
>


here you go:
(I was grabbing the info
after rmmod and modprobe)

[    7.034242] ATH9K: cachelsz: 256
[   69.175348] ATH9K: cachelsz: 256



Justin P. Mattock
