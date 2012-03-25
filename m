Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2CYP24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 11:28:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47002 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab2CYP2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 11:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <4F6E728A.3090203@yahoo.co.jp>
References: <4F5ECD06.3000608@yahoo.co.jp>
	<4F5F7C4C.7080800@teksavvy.com>
	<4F662AFB.9050106@yahoo.co.jp>
	<CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com>
	<4F6AAC37.7040907@yahoo.co.jp>
	<4F6B30D9.2070805@yahoo.co.jp>
	<CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com>
	<4F6B679C.60004@yahoo.co.jp>
	<CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com>
	<4F6C1AE5.5060405@yahoo.co.jp>
	<CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com>
	<4F6C4967.80309@yahoo.co.jp>
	<4F6E728A.3090203@yahoo.co.jp>
Date: Sun, 25 Mar 2012 08:28:52 -0700
Message-ID: <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port
 Multiplier Sil3726
From: Gwendal Grignou <gwendal@google.com>
To: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reread your logs.

Assuming you don't mind long boot from cold power, the remaining
problem is with the 4 disk enclosures [ata7-ata10] on the second
machines where the first disk is not found and boot from warm reboot
is very long.
I try to understand why it works with the other 4 enclosures
[ata5-ata6] on the first and second machines.

Also, just to be sure I understand you configuration correctly, your
second machine has 30 disks total, not 40:
2 direct on ata1.00  and ata1.01
8 on 2 enclosures [ 2 * 4] on ata5 and ata6
20 on 4 enclosures [ 4 * 5] on ata7 - ata10

Also, from the log, ata5 and ata6 is behind a Sil3132 based
controller, while ata7-ata10 behind a single Sil3124, not the opposite
as you said in a precedent mail.

If possible, could you switch 2 of the 4 enclosures [with their disks]
that fails to the port controlled by the Sil3132 controller, reboot
the machine with all its 30 drives and see if the failures follow the
controller or the enclosure.
If you based your raid configuration on signature that should be fine,
but if it based on kernel device name [sdX] that will confuse md and
will mess with your data.

I am sorry I don't have any other suggestion right now,

Regards,
Gwendal.

On Sat, Mar 24, 2012 at 6:19 PM, ANEZAKI, Akira
<fireblade1230@yahoo.co.jp> wrote:
> Hello Gwendal,
>
> I want to confirm one thing.
> The kernel 3.1.x driver still works?
>
> It seems to take long time to solve the problem. Of course I understand
> staggered spin-up is better solution. But I can't wait it so long. And
> it affects only SiI3726 only.
>
> Best Regards,
> Akira
>
> (2012/03/23 18:59), ANEZAKI, Akira wrote:
>> Hello Gwendal,
>>
>> (2012/03/23 17:31), Gwendal Grignou wrote:
>>>>>>> I notice however some messages I did not see before:
>>>>>>>>> [    4.856382] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>>>>>>>> [    4.858742] ata7.00: hard resetting link
>>>>>>>>> [   14.843039] ata7.00: softreset failed (timeout)
>>>>>>>>> [   17.836402] ata7.15: qc timeout (cmd 0xe4)
>>>>>>> The later indicates that the PMP is stuck and the host can not read
>>>>>>> its internal register.
>>>>>>> Is it possible that the PMP in these 4 enclosures you are using have a
>>>>>>> different firmware than the other ones?
>>>>>>> Firmware 1.0114 is available at:
>>>>>>> http://www.siliconimage.com/support/searchresults.aspx?pid=26&cat=23
>>>>>>>
>>>>>>> From the release notes:
>>>>>>> """- Fix SRST and initial two RegFIS Problem."""
>>>>
>>>> I'm still fixing broken RAID. Sorry for my slow response.
>>
>> I checked those firmware version. All of them use version 1.0114.
>>
>> Best Regards,
>> Akira
>
