Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1CVShY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:37:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33070 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1CVShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=AO3AfTm8u7YhKTe4Z9d37CRgGwBl6UO4d+Eikdud6RbbcBqsGzGCrFekdJNh+sHBrL
         hvtBCB/cMGvBK1FT40na9r77Fn8UdSH3Xd8L2PDM7ifwyRfi/Bug/oYOxXDU6gTo/gDP
         fHlfWj0RTYMift7VJGlcV80Z1ZauSy6DcqsiI=
Message-ID: <4D88EC5C.9030809@linaro.org>
Date: Tue, 22 Mar 2011 18:37:16 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jaswinder Singh <jaswinder.singh@linaro.org>
CC: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, benh@kernel.crashing.org, grant.likely@secretlab.ca,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org>	<AANLkTikEtneWEu4iQgfKw-zkAT3Z=e7ohXgDq7oJAQvv@mail.gmail.com>	<4D88C884.4020600@linaro.org> <AANLkTikArWRWcJJRu-3rbJYanHxa4jKu2oovtLztUsk9@mail.gmail.com>
In-Reply-To: <AANLkTikArWRWcJJRu-3rbJYanHxa4jKu2oovtLztUsk9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 06:19 PM, Somebody in the thread at some point said:

Hi -

>>>   Personally, I wouldn't have bothered thinking about some kernel-wide
>>> solution to the Panda SMSC9514 issue. I think defining Panda specific
>>>   udev rules to 'rename the SMSC9614 on USB1(?) to ETH0' is sufficient and
>>> legal to do. Bus enumeration algos change neither often nor enough.
>>> I believe there would be far riskier assumptions in filesystems already.
>>
>> Not sure you got all the points there.  The interface index is not targeted
>> at all, it's the interface class.  That is why I only talk about usb%d vs
>> eth%d.

> I thought I understood. You want the RJ-45 port of _Panda_ be
> called ethN(say eth0) rather than usbN, while other USB-Ethernet adaptors,
> if any and SMSC9514, connected to the USB downstream ports of
> LAN9514 be named usbN.

That's right, your talk of usb1 eth0 made it sound like it had gotten 
mixed up with interface numbering business again.  I guess you did have 
the point then.

> If yes, isn't that possible by specifying a _Panda_ specific udev rule
> to find and rename a network interface based only on its type and
> devpath without needing its MAC address?  Greg ?
> The udev rule could be a part of some hwpack.

We are in a privileged position to suggest to stick all kinds in our 
distro support that's specific to the target, and maintain it.  However 
just doing that relies on the current situation that people are cooking 
rootfs-es that only work on one target.  With the move to multi-target 
single kernel images, and the corresponding multi-target bootloader 
support along the same lines that's coming, it'll eventually be possible 
to provide single SD images that run on many targets with common rootfs. 
  Adding more static hacks into hwpacks on the assumption it is "a panda 
rootfs" goes in the wrong direction for that.

If it was solved with a flag ultimately in the board definition file of 
the kernel, however that manifests itself eventually to do the actual 
job, because that should be the single place all board-specific 
knowledge is coming from as it stands, it'll just work on all distros 
without contaminating them with our userland quirk database (be it held 
in hwpacks or the initscripts).

>>> (b) IMHO, though stable enough, the most obvious method of 'devpath
>>> association'
>>>   is indeed not future-proof.
>>
>> What're you thinking it's not future-proof against?
>
> Even if the rootfilesystem remains the same, the devpath association will
> fail if, say, Linux USB core decides to number usb busses in reverse order as
> a part of some code restructuring.
> After all the USB spec doesn't say about the bus/port ordering.

No that won't hurt anything since, as I said, the static paths are in 
the same tree, and can be updated to the new -- equally deterministic -- 
name at the same time as people start numbering their buses backwards. 
For example, the Panda SDIO module WLAN function is at path 
"mmc1:0001:2", if a patchset comes and decides to call these guys sdio0 
on that bus instead it just has to grep the board definition files for 
mmc.\: and fix those up to the appropriate sdioN convention at the same 
time and everything is cool.

-Andy
