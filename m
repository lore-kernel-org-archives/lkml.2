Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1GMQqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:46:37 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59977 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab1GMQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:46:35 -0400
Date: Wed, 13 Jul 2011 11:46:27 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Arnd Bergmann <arnd@arndb.de>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <201107131835.25217.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1107131144250.3174@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <m2sjqa2q93.fsf@bob.laptop.org> <alpine.DEB.2.02.1107131031360.3174@lazy> <201107131835.25217.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris,

Do you think that lowering the controller speed to 50Mhz in case we have a 
failure is a better idea than reducing the speed for all e823 ricoh 
controllers? I can send a V2 of the patch. What do you think ?

On Wed, 13 Jul 2011, Arnd Bergmann wrote:

> On Wednesday 13 July 2011, Manoj Iyer wrote:
>>
>> Chris/Arnd,
>>
>> Here is a series of test I did with the patched kernel.
>
>> == cold boot insert SD card ==
>> u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 *
>> 1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
>> 4MiB    4.96M/s
>> 2MiB    6.3M/s
>> 1MiB    6.23M/s
>> 512KiB  6.23M/s
>> 256KiB  6.26M/s
>
> The very first one obviously triggers a garbage collection.
> Everything after that is well within measuring accuracy around 6.25MB/s
>
>> On Wed, 13 Jul 2011, Chris Ball wrote:
>
>>>
>>> That makes sense.  Do you think this explains Manoj getting a slower
>>> first file copy speed (757ms vs. 480ms) after applying his patch?
>>> (Manoj, perhaps you could retry your test without GC being needed?)
>
> Yes. For a single sample, it can easily explain differences up to 500ms.
> You have to average out file system benchmarks across a lot of files
> to be sure.
>
>>> What would we expect lowering the SD base clock frequency from 200MHz
>>> to 50MHz to do to performance theoretically?
>
> Not much. This card only has a 6MB/s write speed, which is well below
> what a 50 MHz bus can do. It mgiht be different on a fast eMMC device
> or a Sandisk Extreme Pro UHS-1 card.
>
> 	Arnd
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
