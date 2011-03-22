Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1CVS7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:59:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45893 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1CVS7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:59:04 -0400
MIME-Version: 1.0
In-Reply-To: <4D88EC5C.9030809@linaro.org>
References: <4D79F068.2080009@linaro.org>
	<AANLkTikEtneWEu4iQgfKw-zkAT3Z=e7ohXgDq7oJAQvv@mail.gmail.com>
	<4D88C884.4020600@linaro.org>
	<AANLkTikArWRWcJJRu-3rbJYanHxa4jKu2oovtLztUsk9@mail.gmail.com>
	<4D88EC5C.9030809@linaro.org>
Date: Wed, 23 Mar 2011 00:29:01 +0530
Message-ID: <AANLkTimrH31ZE_ra6giWBun+Vp61V+3csghG5sOWk58h@mail.gmail.com>
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

On 23 March 2011 00:07, Andy Green <andy@warmcat.com> wrote:
> On 03/22/2011 06:19 PM, Somebody in the thread at some point said:

>> If yes, isn't that possible by specifying a _Panda_ specific udev rule
>> to find and rename a network interface based only on its type and
>> devpath without needing its MAC address?  Greg ?
>> The udev rule could be a part of some hwpack.
>
> We are in a privileged position to suggest to stick all kinds in our distro
> support that's specific to the target, and maintain it.  However just doing
> that relies on the current situation that people are cooking rootfs-es that
> only work on one target.  With the move to multi-target single kernel
> images, and the corresponding multi-target bootloader support along the same
> lines that's coming, it'll eventually be possible to provide single SD
> images that run on many targets with common rootfs.  Adding more static
> hacks into hwpacks on the assumption it is "a panda rootfs" goes in the
> wrong direction for that.
Yes I know it's not a very elegant solution.
But we must remember, we are catering to users that lose sleep over
not having to call 'fixed RJ-45 port over USB' as eth0 :)

>>>> (b) IMHO, though stable enough, the most obvious method of 'devpath
>>>> association'
>>>>  is indeed not future-proof.
>>>
>>> What're you thinking it's not future-proof against?
>>
>> Even if the rootfilesystem remains the same, the devpath association will
>> fail if, say, Linux USB core decides to number usb busses in reverse order
>> as
>> a part of some code restructuring.
>> After all the USB spec doesn't say about the bus/port ordering.
>
> No that won't hurt anything since, as I said, the static paths are in the
> same tree, and can be updated to the new -- equally deterministic -- name at
> the same time as people start numbering their buses backwards. For example,
> the Panda SDIO module WLAN function is at path "mmc1:0001:2", if a patchset
> comes and decides to call these guys sdio0 on that bus instead it just has
> to grep the board definition files for mmc.\: and fix those up to the
> appropriate sdioN convention at the same time and everything is cool.

I was not just talking about mmc -> sdio change. Rather the bus/port numbering.
Say, mmc1:0001:2 becomes mmc7:0201:1 by some new addressing scheme.
I agree the fix is as easy as it is to break old devpath assumption in
this case.

And yes, bus numbering also depends on things like modprobe order, which may not
be fixed for all platforms. Any change there too can break the devpath
association.

Let's see what other veterans suggest.

Best of luck.
