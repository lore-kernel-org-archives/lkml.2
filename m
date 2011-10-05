Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab1JESTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:19:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596Ab1JEST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:19:26 -0400
Date: Wed, 5 Oct 2011 13:19:08 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@sleepy
To: Josh Boyer <jwboyer@redhat.com>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>,
        Koji Matsumuro <matsumur@nts.ricoh.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Always check for lower base frequency quirk for
 Ricoh 1180:e823
In-Reply-To: <20111005164306.GC2479@zod.bos.redhat.com>
Message-ID: <alpine.DEB.2.02.1110051313470.3478@sleepy>
References: <20111005154449.GA2479@zod.bos.redhat.com> <alpine.DEB.2.02.1110051059550.3478@sleepy> <20111005164306.GC2479@zod.bos.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Josh Boyer wrote:

> On Wed, Oct 05, 2011 at 11:27:01AM -0500, Manoj Iyer wrote:
>> On Wed, 5 Oct 2011, Josh Boyer wrote:
>>
>>> Commit 15bed0f2f added a quirk for the e823 Ricoh card reader to lower the
>>> base frequency.  However, the quirk first checks to see if the proprietary
>>> MMC controller is disabled, and returns if so.  On some devices, such as the
>>> Lenovo X220, the MMC controller is already disabled by firmware it seems,
>>
>> It is possible that the newer firmware from Lenovo disables the MMC
>> controller. When the patch was done, these laptops had just been
>> announced, so they had a very early version of the firmware (ver
>> 1.02 iirc).
>
> Seems so.  The X220 laptop I debugged this on shows:
>
> [jwboyer@zod linux-2.6]$ cat /sys/devices/virtual/dmi/id/bios_version
> 8DET42WW (1.12 )

I was able to track down the one I debugged, luckily the firmware on it was 
never updated, and great! the bios is even older than I thought...

u@u:~$ cat /sys/devices/virtual/dmi/id/bios_version
8DET25WW (0.25 )
u@u:~$

So, yes definitely looks like BIOS might have disabled MMC in the newer 
releases. /me wonders when IBVs will get their act together ...

>
> josh
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
