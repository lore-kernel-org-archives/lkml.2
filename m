Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1JMPLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:11:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45353 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1JMPLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:11:00 -0400
Message-ID: <4E96FF2C.5070101@mvista.com>
Date: Thu, 13 Oct 2011 19:09:32 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_via: add via_fixup()
References: <201110131310.51896.bzolnier@gmail.com> <4E96D81F.8000400@mvista.com> <201110131454.48888.bzolnier@gmail.com>
In-Reply-To: <201110131454.48888.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/13/2011 04:54 PM, Bartlomiej Zolnierkiewicz wrote:

>> On 13-10-2011 15:10, Bartlomiej Zolnierkiewicz wrote:

>>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>> Subject: [PATCH] pata_via: add via_fixup()

>>> Factor out common code from via_[re]init_one() to via_fixup().

>>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>> ---
>>> earlier references:
>>> https://lkml.org/lkml/2009/11/25/381

>>>    drivers/ata/pata_via.c |   49 +++++++++++++++++++++++--------------------------
>>>    1 file changed, 23 insertions(+), 26 deletions(-)

>>> Index: b/drivers/ata/pata_via.c
>>> ===================================================================
>>> --- a/drivers/ata/pata_via.c
>>> +++ b/drivers/ata/pata_via.c
>>> @@ -491,6 +491,27 @@ static void via_config_fifo(struct pci_d
>>>    	}
>>>    }
>>>
>>> +static void via_fixup(struct pci_dev *pdev, const struct via_isa_bridge *config)
>>> +{
>>> +	u32 timing;
>>> +
>>> +	/* Initialise the FIFO for the enabled channels. */
>>> +	via_config_fifo(pdev, config->flags);
>>> +
>>> +	if (config->udma_mask == ATA_UDMA4) {
>>> +		/* The 66 MHz devices require we enable the clock */
>>> +		pci_read_config_dword(pdev, 0x50,&timing);
>>> +		timing |= 0x80008;
>>> +		pci_write_config_dword(pdev, 0x50, timing);
>>> +	}

>>      Hm, via_init_one() doesn't do this now... but used to do this before your
>> patch:

>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=460f5318460a9a3b2562d8055b9fb1c60b768e1f

>>      Was that patch wrong or am I misundertanding?

> It seems that the previous patch was wrong and I haven't noticed it earlier
> because both patches were in my patch queue.

> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH v2] pata_via: add via_fixup()

> * Fix via_init_one() to enable clock on 66 MHz devices
>    (bug introduced in commit 460f531 "pata_via: store UDMA masks
>     in via_isa_bridges table").

> * Factor out common code from via_[re]init_one() to via_fixup().

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>

    OK, but don't you think the fix should be separate from refactor (and be 
applied to -stable)?

WBR, Sergei
