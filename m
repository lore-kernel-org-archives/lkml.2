Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2A0SkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:40:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50641 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2A0Sj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <20120127102218.3dde7360@jbarnes-desktop>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-18-git-send-email-yinghai@kernel.org>
	<20120127102218.3dde7360@jbarnes-desktop>
Date: Fri, 27 Jan 2012 10:39:57 -0800
X-Google-Sender-Auth: V3YYGO-xW9OZr70I-bG69zPCCgw
Message-ID: <CAE9FiQV2_zTpN6B98SFCL79GwSYGwajG=xr_0qOMoesS-crwow@mail.gmail.com>
Subject: Re: [PATCH 17/21] PCI: Disable cardbus bridge MEM1 pref CTL
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:22 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sat, 21 Jan 2012 02:08:33 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Some BIOS enable both pref for MEM0 and MEM1.
>>
>> but we assume MEM1 is non-pref...
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/setup-bus.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 090217a..d5897c3 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -914,6 +914,14 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
>>       if (realloc_head)
>>               add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
>>
>> +     /* MEM1 must not be pref mmio */
>> +     pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
>> +     if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM1) {
>> +             ctrl &= ~PCI_CB_BRIDGE_CTL_PREFETCH_MEM1;
>> +             pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
>> +             pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
>> +     }
>> +
>>       /*
>>        * Check whether prefetchable memory is supported
>>        * by this bridge.
>
> Is there an actual bug report for this one where prefetchable regions
> are causing trouble?  I can see that they would I just wonder if this
> bug is hidden by some other...

Yes, it should be hidden  by some others.

Yinghai
