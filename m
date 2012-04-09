Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab2DIQl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:41:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64818 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2DIQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:41:55 -0400
Message-ID: <4F83114E.30106@openvz.org>
Date: Mon, 09 Apr 2012 20:41:50 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: v3.4 BUG: Bad rss-counter state
References: <20120408113925.GA292@x4> <20120409055814.GA292@x4>
In-Reply-To: <20120409055814.GA292@x4>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> On 2012.04.08 at 13:39 +0200, Markus Trippelsdorf wrote:
>> I've hit the following warning after I've tried to link Firofox's libxul
>> with "-flto -lto-partition=none" on my machine with 8GB memory. I've
>> killed the process after it used all the memory and 90% of my swap
>> space. Before the machine was rebooted I saw these messages:
>>
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813c380 idx:1 val:-1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813c380 idx:2 val:1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88021503bb80 idx:1 val:-1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fb643b80 idx:1 val:-1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fb643b80 idx:2 val:1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88021503bb80 idx:2 val:1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020a4ff800 idx:1 val:-1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020a4ff800 idx:2 val:1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813ce00 idx:1 val:-1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff88020813ce00 idx:2 val:1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fadda680 idx:1 val:-1
>> Apr  8 13:11:08 x4 kernel: BUG: Bad rss-counter state mm:ffff8801fadda680 idx:2 val:1
>
> BTW, I'm not the only one that sees these messages. Here are two more
> reports from Ubuntu beta testers:
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/963672
> BUG: Bad rss-counter state mm:ffff88022107fb80 idx:1 val:-14
> BUG: Bad rss-counter state mm:ffff88022107fb80 idx:2 val:14
>
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/965709
> BUG: Bad rss-counter state mm:c8fd9dc0 idx:1 val:-2
> BUG: Bad rss-counter state mm:c8fd9dc0 idx:2 val:2
> usb 5-1: USB disconnect, device number 2
> usb 5-1: new low-speed USB device number 3 using uhci_hcd
> input: Mega World Thrustmaster dual analog 3.2 as
> /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input13
> generic-usb 0003:044F:B315.0004: input,hidraw1: USB HID v1.10 Gamepad
> [Mega World Thrustmaster dual analog 3.2] on usb-0000:00:1d.0-1/input0
> BUG: Bad rss-counter state mm:c8fd9dc0 idx:1 val:-2
> BUG: Bad rss-counter state mm:c8fd9dc0 idx:2 val:2
> BUG: Bad rss-counter state mm:dea3cc40 idx:1 val:-1
> BUG: Bad rss-counter state mm:dea3cc40 idx:2 val:1
>
> The pattern seem to be:
> ... idx:1 val:-x
> ... idx:2 val:x
> for x=1,2,14
>

Ok, thanks. I'll try to figure out how this is happened.
