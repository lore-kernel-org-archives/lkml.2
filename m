Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab0L1O13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:27:29 -0500
Received: from 31.mail-out.ovh.net ([213.186.62.10]:44068 "HELO
	31.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753561Ab0L1O11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 09:27:27 -0500
Message-ID: <4D19F3C1.8010208@example.com>
Date: Tue, 28 Dec 2010 15:27:13 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101211 Icedove/3.0.11
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 27
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>	<4D18A480.2060309@example.com>	<AANLkTi=WhSP1ceHBW95n1e-gHwwnt36h3czFGuKsEny6@mail.gmail.com>	<4D18A972.1020205@example.com>	<AANLkTikCeqCLmDJAnf9uT6wW+OLkRop-FJ9MDrMM_oX7@mail.gmail.com>	<4D18AD30.9070707@example.com>	<4D18B4A2.1030107@example.com> <AANLkTim1Cj1rbgnFr6C7==UP+jiriJ55Kcu9wmgd+DKh@mail.gmail.com>
In-Reply-To: <AANLkTim1Cj1rbgnFr6C7==UP+jiriJ55Kcu9wmgd+DKh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17566290347453804960
X-Ovh-Remote: 178.42.66.207 (afmo207.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.12.2010 17:16, Sedat Dilek wrote:
> 2010/12/27 Piotr Hosowicz<piotr@hosowicz.com>:
>> On 27.12.2010 16:13, Piotr Hosowicz wrote:
>>>
>>> On 27.12.2010 16:08, Sedat Dilek wrote:
>>>>
>>>> 2010/12/27 Piotr Hosowicz<piotr@hosowicz.com>:
>>>>>
>>>>> On 27.12.2010 15:48, Sedat Dilek wrote:
>>>>>>
>>>>>> 2010/12/27 Piotr Hosowicz<piotr@hosowicz.com>:
>>>>>>>
>>>>>>> On 27.12.2010 07:04, Stephen Rothwell wrote:
>>>>>>>
>>>>>>> Hello,
>>>>>>>
>>>>>>> I noticed that after first reboot with this kernel that my MP3
>>>>>>> collection
>>>>>>> in
>>>>>>> mocp layed on Ext4 fs opens painfully slow. It is not my mistake,
>>>>>>> because
>>>>>>> I
>>>>>>> always do it the same way, new kernel, then music on. The problem
>>>>>>> is not
>>>>>>> present in rc7-git4. I could measure it in some way (timing ls -la
>>>>>>> in tht
>>>>>>> dir?) if somebody needs it.
>>>>>>>
>>>>>>> Regards,
>>>>>>>
>>>>>>> Piotr Hosowicz
>>>>>>>
>>>>>>
>>>>>> You tried mblk_io_submit mount-option for that partition?
>>>>>
>>>>> No, I do not use it, I do not even know what it is. My options are:
>>>>>
>>>>> /dev/sda2 on / type ext4 (rw,errors=remount-ro)
>>>>>
>>>>
>>>> Have a closer look at "ext4: Turn off multiple page-io submission by
>>>> default"
>>>
>>> I tried to Google for mblk_io_submit but I didn't find anything helpful.
>>> Could you tell me how should I add this option in fstab and what will be
>>> its effect?
>>
>> As far as I understand that option regards writing, not reading. The
>> symptoms I described occured while reading only.
>>
>
> That's the only performance issue I am aware of in ext4 in recent time.
> Why don't you try it and present some numbers in transfer ratio (write, read)?

Ok, I'll try to measure it in shell. Now I am building newest non-next 
kernel and the trial script is:

#!/bin/bash

uname -a
mount
cd /data/music
time ls -d *
cd -

This is basically what mocp does when it enters my music directory, 
apart from displaying the results in ncurses based UI. Then I'll reboot 
with next kernel and run it again. Will it do?

Regards,

Piotr Hosowicz

-- 
Kto¶ zapuka³ do drzwi.
-Bormann - pomy¶la³ Stirlitz
-Tak, to ja - pomy¶la³ Bormann
NP: Peter Green Splinter Group - Madison Blues
NB: 2.6.37-rc7-20101227-pztidm+
