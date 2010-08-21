Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0HUTNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:13:30 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:51779 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486Ab0HUTN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:13:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJLCb0xLd/sX/2dsb2JhbAAHgxHGXpEegSKBS4FXcwQ
X-IronPort-AV: E=Sophos;i="4.56,247,1280721600"; 
   d="scan'208";a="73129836"
Message-ID: <4C702554.4040005@teksavvy.com>
Date: Sat, 21 Aug 2010 15:13:24 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Nicolas Jungers <nicolas@jungers.net>
CC: linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: possible esata regression in 2.6.35
References: <4C702070.5020809@jungers.net>
In-Reply-To: <4C702070.5020809@jungers.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-08-21 02:52 PM, Nicolas Jungers wrote:
> My arm box doesn't succeed to use my esata port multiplier (addonics sil3726 based).  It was working well with 2.6.34.1 and 2.6.34.4 but not with both 2.6.35.2 and 2.6.35.3.  I haven't test other kernels.
>
> The kernels are from http://sheeva.with-linux.com/sheeva/ with for example the following config http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config
>
> The symptoms are in the console a loop on the esata links. Here is the start of it:
>
> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
> ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
> ata2: SError: { PHYRdyChg DevExch }
> ata2: hard resetting link
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> ata2.00: hard resetting link
> ata2.01: hard resetting link
> ata2.02: hard resetting link
> ata2.03: hard resetting link
> ata2.04: hard resetting link
> ata2.05: hard resetting link
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.15: hard resetting link
> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ata2.00: hard resetting link
> ata2.01: hard resetting link
> ata2.02: hard resetting link
> ata2.04: hard resetting link
> ata2.05: hard resetting link
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.15: hard resetting link
> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ata2.00: hard resetting link
> ata2.01: hard resetting link
> ata2.02: hard resetting link
> ata2.03: hard resetting link
> ata2.04: hard resetting link
> ata2.05: hard resetting link
> ata2.00: qc timeout (cmd 0xec)
> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.00: failed to recover link after 3 tries, disabling
> ata2.15: hard resetting link
> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
...

 From the "edma_err" keyword above, we can deduce that you've got this PM
plugged into a Marvell SATA controller of some kind, managed by sata_mv.
Care to tell us more?

There are various changes in libata in 2.6.34/35 that break sata_mv,
particularly for ATAPI drives and any SSDs that support the DSM/TRIM commands.
Do either of those two things apply in your case?

If so, there are two pending patches which fix them.
They were posted to linux-ide this past Thursday,
and can also be found as attachments to this bug report:

   https://bugzilla.kernel.org/show_bug.cgi?id=16434

Cheers
