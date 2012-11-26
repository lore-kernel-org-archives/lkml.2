Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab2KZQnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:43:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2KZQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:43:04 -0500
Date: Mon, 26 Nov 2012 10:42:55 -0600 (CST)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Chris Ball <cjb@laptop.org>
cc: Manoj Iyer <manoj.iyer@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock
 frequency
In-Reply-To: <87obiqa39h.fsf@octavius.laptop.org>
Message-ID: <alpine.DEB.2.02.1211261041500.3502@lazy>
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <m2sjqa2q93.fsf@bob.laptop.org> <alpine.DEB.2.02.1107131031360.3174@lazy> <201107131835.25217.arnd@arndb.de> <alpine.DEB.2.02.1107131144250.3174@lazy> <m21uxu2k96.fsf@bob.laptop.org>
 <alpine.DEB.2.02.1107131157440.3174@lazy> <m2wrfm1537.fsf@bob.laptop.org> <alpine.DEB.2.02.1107181535250.1677@lazy> <m2zkkbb9vn.fsf@bob.laptop.org> <alpine.DEB.2.02.1107181546100.1677@lazy> <87obiqa39h.fsf@octavius.laptop.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris,

Do you know what systems produce these errors? I can look and see if we 
have those for testing your patch.

Cheers
Manoj

On Wed, 21 Nov 2012, Chris Ball wrote:

> Hi Manoj, Matsumuro-san,
>
> On Mon, Jul 18 2011, Manoj Iyer wrote:
>> Right, without the patch I get..
>>
>> [   52.526665] mmc0: new SDHC card at address e624
>> [   52.571228] mmcblk0: mmc0:e624 SD16G 14.8 GiB
>> [   52.591071] mmcblk0: retrying using single block read
>> [   52.593105] mmcblk0: error -84 transferring data, sector 0, nr 8,
>> card status 0x900
>> [   52.593109] end_request: I/O error, dev mmcblk0, sector 0
>> [   52.594594] mmcblk0: error -84 transferring data, sector 1, nr 7,
>> card status 0x900
>> [   52.594604] end_request: I/O error, dev mmcblk0, sector 1
>> [   52.602893] quiet_error: 24 callbacks suppressed
>> [   52.602902] Buffer I/O error on device mmcblk0, logical block 0
>> [   52.605349] ldm_validate_partition_table(): Disk read failed.
>> [   52.605384] Dev mmcblk0: unable to read RDB block 0
>> [   52.607729]  mmcblk0: unable to read partition table
>> u@u:~$
>>
>> So, I cannot generate any comparison data with this SD card.
>
> I don't know if you remember this bug, but I have reports from two users
> who see "error -84"s on :e823 controllers even with this patch active on
> modern ThinkPads.
>
> Maybe 50MHz isn't low enough sometimes?  Is it possible to lower the base
> clock further?
>
> I noticed that the frequency is encoded ine one of the PCI writes:
> +        * 0x32  - 50Mhz new clock frequency
>
> So if I get access to one of these systems, I might try lowering that
> value (by half, say) and see what happens.  But at the moment I haven't
> found someone who's willing to try kernel patches yet, and I don't have
> one of these systems myself.
>
> Thanks!
>
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
