Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1CVPFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:05:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65246 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1CVPFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <4D79F068.2080009@linaro.org>
References: <4D79F068.2080009@linaro.org>
Date: Tue, 22 Mar 2011 20:35:40 +0530
Message-ID: <AANLkTikEtneWEu4iQgfKw-zkAT3Z=e7ohXgDq7oJAQvv@mail.gmail.com>
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

[CC'ed interested parties in retrospect and resent in plain text]

On 11 March 2011 15:20, Andy Green <andy@warmcat.com> wrote:
>
> Hi -
>
> platform_data is a well established way in Linux to pass configuration data up to on-board assets from a machine file like mach-xyz.c.  It's also supported to pass platform_data up to devices that are probed asynchronously from busses like i2c as well, which is very handy.
>
> However AFAIK it's not possible to bind platform_data to probed USB devices as it stands.
>
> There are now boards which have on-board USB assets, for example OMAP4 Panda which has a USB <-> Ethernet bridge wired up permanently.  It'd be convenient to also be able to pass optional platform_data to these devices when they are asynchronously probed.
>
> So what's the feeling about a new api to register an array of platform_data pointers bound to static "devpath" names in the machine file?
>
> When a usb device is instantiated, it can check through this array if it exists, matching on devname, and attach the platform_data to the underlying probed usb device's dev->platform_data, which it seems is currently unused.
>
> The particular use that suggested this is on Panda, it would be ideal to be able to set a flag in the usb device's platform data that forces it to be named eth%d since it's a hardwired asset on the board with an RJ45 socket.
>
> Comments, implementation suggestions, enquiries as to my level of crack consumption etc welcomed ^^


Hi Andy,

 Personally, I wouldn't have bothered thinking about some kernel-wide
solution to the Panda SMSC9514 issue. I think defining Panda specific
 udev rules to 'rename the SMSC9614 on USB1(?) to ETH0' is sufficient and
legal to do. Bus enumeration algos change neither often nor enough.
I believe there would be far riskier assumptions in filesystems already.

But I do agree it is nice to have system wide solutions whenever due.
Like this attempted patchset. Which is based upon two questions :-

Q(a) Can discoverable buses(USB, SDIO etc) legally need platform_data
or similar?

Q(b) If yes, what 'key' is most suitable for identifying the right device
  to attach the data to ?

(a) We already have a good example, of Panda's missing MAC. I am sure there
 would be more to think of.
   Though it is illegal for a NIC to not have MAC address, no spec demands the
 MAC be on some EEPROM or like. Theoretically, the NIC vendor could
hand me a NIC
and a note with it's unique MAC address scribbled :)
 As Mark already noted, savings pile if we could save eeproms when a device is
expected to ship in tens of thousands.
 IIANM, Greg acknowledged passing MAC via board specific data
structure(albeit via DT)
It's a different matter that DT has many hearts to win(at least in ARM Linux)
So, perhaps the answer to Q(a) is - Yes.

(b) IMHO, though stable enough, the most obvious method of 'devpath association'
 is indeed not future-proof.
 Having parent pointers to compare sounds like a bit too intrusive.
 People might want to suggest?

Thanks.
