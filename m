Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1CVSTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:19:53 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46944 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1CVSTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <4D88C884.4020600@linaro.org>
References: <4D79F068.2080009@linaro.org>
	<AANLkTikEtneWEu4iQgfKw-zkAT3Z=e7ohXgDq7oJAQvv@mail.gmail.com>
	<4D88C884.4020600@linaro.org>
Date: Tue, 22 Mar 2011 23:49:51 +0530
Message-ID: <AANLkTikArWRWcJJRu-3rbJYanHxa4jKu2oovtLztUsk9@mail.gmail.com>
Subject: Re: RFC: Platform data for onboard USB assets
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: andy.green@linaro.org
Cc: Andy Green <andy@warmcat.com>, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, benh@kernel.crashing.org, grant.likely@secretlab.ca,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2011 21:34, Andy Green <andy@warmcat.com> wrote:
> On 03/22/2011 03:05 PM, Somebody in the thread at some point said:
>
> Hi -
>
>>  Personally, I wouldn't have bothered thinking about some kernel-wide
>> solution to the Panda SMSC9514 issue. I think defining Panda specific
>>  udev rules to 'rename the SMSC9614 on USB1(?) to ETH0' is sufficient and
>> legal to do. Bus enumeration algos change neither often nor enough.
>> I believe there would be far riskier assumptions in filesystems already.
>
> Not sure you got all the points there.  The interface index is not targeted
> at all, it's the interface class.  That is why I only talk about usb%d vs
> eth%d.
>
> If you think about what userland has to do to correct that, it involves
> userland understanding that it is running on specifically a Panda board or
> other boards that need mangling, and it is looking at the device that is
> specifically the onboard one.  (You cannot do it from VID/PID because that
> same VID/PID can turn up in a second pluggable adapter case -- still an
> smsc95xx you see -- where you really would want it called usb%d.)  This is
> why elsewhere I refer to this as a "userland board quirk database" being
> needed to solve it in userland.  If it was simpler, sure, I wouldn't bother
> looking to guide the driver's choice in kernel because you can as pointed
> out meddle them from userland.  But if you look into what has to be done in
> Userland it's nothing like a normal udev handler based only on vid/pid.
>  Userland is actually super allergic to knowing directly what it is running
> on and making decisions based on that, for good reasons, and desperately
> wants to be generic leaving all board quirks for the kernel to hide.  And
> the machine definition file is designed to understand board-specific
> information.

I thought I understood. You want the RJ-45 port of _Panda_ be
called ethN(say eth0) rather than usbN, while other USB-Ethernet adaptors,
if any and SMSC9514, connected to the USB downstream ports of
LAN9514 be named usbN.

If yes, isn't that possible by specifying a _Panda_ specific udev rule
to find and rename a network interface based only on its type and
devpath without needing its MAC address?  Greg ?
The udev rule could be a part of some hwpack.


>>    Though it is illegal for a NIC to not have MAC address, no spec demands
>> the
>>  MAC be on some EEPROM or like. Theoretically, the NIC vendor could
>> hand me a NIC
>> and a note with it's unique MAC address scribbled :)
>>  As Mark already noted, savings pile if we could save eeproms when a
>> device is
>> expected to ship in tens of thousands.
>>  IIANM, Greg acknowledged passing MAC via board specific data
>> structure(albeit via DT)
>> It's a different matter that DT has many hearts to win(at least in ARM
>> Linux)
>> So, perhaps the answer to Q(a) is - Yes.
>>
>> (b) IMHO, though stable enough, the most obvious method of 'devpath
>> association'
>>  is indeed not future-proof.
>
> What're you thinking it's not future-proof against?

Even if the rootfilesystem remains the same, the devpath association will
fail if, say, Linux USB core decides to number usb busses in reverse order as
a part of some code restructuring.
After all the USB spec doesn't say about the bus/port ordering.

Thanks.
