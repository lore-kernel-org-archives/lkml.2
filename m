Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab2BJUyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:54:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53057 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2BJUym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:54:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120210124614.5006563e@jbarnes-desktop>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-4-git-send-email-yinghai@kernel.org>
	<20120210124614.5006563e@jbarnes-desktop>
Date: Fri, 10 Feb 2012 12:54:41 -0800
X-Google-Sender-Auth: SE2jLd_2OUW-UAtf0pIkAD8BMSE
Message-ID: <CAE9FiQXeNGP3zj2PhWK_Gcnwr9Qsn6LZ74TL2OA2RrztLaewvg@mail.gmail.com>
Subject: Re: [PATCH 3/9] PCI: Disable cardbus bridge MEM1 pref CTL
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 12:46 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sat,  4 Feb 2012 22:55:02 -0800
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
> Does this actually fix any bugs?

at least, one of laptop have this problem.

> Dominik, have you tested it?

he tested my for-pci3 and for-pci-busn-alloc branches, both branches
have this patch.

and it does not cause problem to him.

Yinghai
