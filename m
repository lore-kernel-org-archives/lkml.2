Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3AHBbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:31:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:9046 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab3AHBbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:31:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,428,1355126400"; 
   d="scan'208";a="241084484"
Message-ID: <50EB770A.4090302@intel.com>
Date: Tue, 08 Jan 2013 09:31:54 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jiri Slaby <jslaby@suse.cz>
CC: Shane Huang <Shane.Huang@amd.com>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ata1: COMRESET failed
References: <508A7A8A.7030908@suse.cz> <50BC8A1C.8070805@suse.cz> <20121203115734.GA32243@liondog.tnic> <20130107172425.GD5954@liondog.tnic>
In-Reply-To: <20130107172425.GD5954@liondog.tnic>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 01:24 AM, Borislav Petkov wrote:
> Adding some more people.
> 
> Aaron, Shane, do you guys have any ideas? I've been seeing something
> similar on an AMD desktop box recently and Jiri sees it on a laptop with
> an SSD.

I've seen a similar problem on a bug report recently for a Crucial SSD,
and upgrading the disk's firmware fixed the problem:
https://bugzilla.kernel.org/show_bug.cgi?id=49701

If the controller has problem, it should have problems for all kinds of
disks attached to it. So possible to test with other disks, Jiri?

Hope this helps.

-Aaron

> 
> Here's Jiri's original mail with more info: http://lkml.org/lkml/2012/10/26/208
> 
> Thanks.
> 
> On Mon, Dec 03, 2012 at 12:57:34PM +0100, Borislav Petkov wrote:
>> On Mon, Dec 03, 2012 at 12:16:44PM +0100, Jiri Slaby wrote:
>>> On 10/26/2012 01:56 PM, Jiri Slaby wrote:
>>>> Hello,
>>>>
>>>> at every boot I'm seeing:
>>>>
>>>> At 5th second:
>>>> ata1: link is slow to respond, please be patient (ready=0)
>>>>
>>>> At 10th second:
>>>> ata1: COMRESET failed (errno=-16)
>>>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>> ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
>>>> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
>>>> ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
>>>> ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
>>>> ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
>>>> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
>>>> ata1.00: configured for UDMA/133
>>>> scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
>>>>
>>>>
>>>> So that I have to wait 5 s for the disk to come up. I tried 3.4.15 and
>>>> 3.6.3, both with the same result.
>>>>
>>>> 00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset
>>>> Family 6-port SATA Controller [AHCI mode] [8086:1e03] (rev 04)
>>>>
>>>> Any ideas what is going on?
>>>
>>> Anybody? I also tried 3.0, it's there too. And libahci.skip_host_reset=1
>>> works around the issue.
>>
>> FWIW, I had the same issue on an AMD chipset at the old job. It needs to
>> reset SATA link for some reason, probably BIOS programs it wrongly...
>>
>> + Alan.
> 

