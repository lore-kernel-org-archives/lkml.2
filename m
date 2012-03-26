Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2CZAlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 20:41:40 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:52988 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab2CZAlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 20:41:36 -0400
Message-ID: <4F6FBB3E.8060409@yahoo.co.jp>
Date: Mon, 26 Mar 2012 09:41:34 +0900
From: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier
 Sil3726
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com> <4F6B679C.60004@yahoo.co.jp> <CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com> <4F6C1AE5.5060405@yahoo.co.jp> <CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com> <4F6C4967.80309@yahoo.co.jp> <4F6E728A.3090203@yahoo.co.jp> <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com>
In-Reply-To: <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

Thank you for your kindness response.

(2012/03/26 00:28), Gwendal Grignou wrote:
> I reread your logs.
> 
> Assuming you don't mind long boot from cold power, the remaining
> problem is with the 4 disk enclosures [ata7-ata10] on the second
> machines where the first disk is not found and boot from warm reboot
> is very long.

Not only first disk. 2 or more HDDs are missed for every PMP.

> I try to understand why it works with the other 4 enclosures
> [ata5-ata6] on the first and second machines.
> 
> Also, just to be sure I understand you configuration correctly, your
> second machine has 30 disks total, not 40:
> 2 direct on ata1.00  and ata1.01
> 8 on 2 enclosures [ 2 * 4] on ata5 and ata6
> 20 on 4 enclosures [ 4 * 5] on ata7 - ata10

Oops! You are right. I'm very sorry!

> Also, from the log, ata5 and ata6 is behind a Sil3132 based
> controller, while ata7-ata10 behind a single Sil3124, not the opposite
> as you said in a precedent mail.
> 
> If possible, could you switch 2 of the 4 enclosures [with their disks]
> that fails to the port controlled by the Sil3132 controller, reboot
> the machine with all its 30 drives and see if the failures follow the
> controller or the enclosure.

Yes, I will do it as soon as possible. (Sorry, resyncing is runnning now.)

> If you based your raid configuration on signature that should be fine,
> but if it based on kernel device name [sdX] that will confuse md and
> will mess with your data.

The problem is that some HDDs on every PMP from ata7 - ata10 are missed.
The RAID problem seems to be caused by it. mdadm.conf uses uuid. So I
think that kernel uses uuids of RAIDs.

Best Regards,
Akira

> I am sorry I don't have any other suggestion right now,

The HDDs connected to ata7 -- ata10 are very old and support only Serial
ATA 1.0a. I checked data sheet and chip(JM20330) supports SRST command.
While booting, indicator LED brinks repeatedly. And more than half of
HDDs are identified. So, I have thought that the HDD side is not a
problem. How is your opinion about it?

> Regards,
> Gwendal.
> 
> On Sat, Mar 24, 2012 at 6:19 PM, ANEZAKI, Akira
> <fireblade1230@yahoo.co.jp> wrote:
>> Hello Gwendal,
>>
>> I want to confirm one thing.
>> The kernel 3.1.x driver still works?
>>
>> It seems to take long time to solve the problem. Of course I understand
>> staggered spin-up is better solution. But I can't wait it so long. And
>> it affects only SiI3726 only.
>>
>> Best Regards,
>> Akira
>>
>> (2012/03/23 18:59), ANEZAKI, Akira wrote:
>>> Hello Gwendal,
>>>
>>> (2012/03/23 17:31), Gwendal Grignou wrote:
>>>>>>>> I notice however some messages I did not see before:
>>>>>>>>>> [    4.856382] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>>>>>>>>> [    4.858742] ata7.00: hard resetting link
>>>>>>>>>> [   14.843039] ata7.00: softreset failed (timeout)
>>>>>>>>>> [   17.836402] ata7.15: qc timeout (cmd 0xe4)
>>>>>>>> The later indicates that the PMP is stuck and the host can not read
>>>>>>>> its internal register.
>>>>>>>> Is it possible that the PMP in these 4 enclosures you are using have a
>>>>>>>> different firmware than the other ones?
>>>>>>>> Firmware 1.0114 is available at:
>>>>>>>> http://www.siliconimage.com/support/searchresults.aspx?pid=26&cat=23
>>>>>>>>
>>>>>>>> From the release notes:
>>>>>>>> """- Fix SRST and initial two RegFIS Problem."""
>>>>>
>>>>> I'm still fixing broken RAID. Sorry for my slow response.
>>>
>>> I checked those firmware version. All of them use version 1.0114.
>>>
>>> Best Regards,
>>> Akira
>>

