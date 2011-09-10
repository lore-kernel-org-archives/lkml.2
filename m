Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab1IJQkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 12:40:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54121 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298Ab1IJQkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 12:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <1315633296.23777.32.camel@Joe-Laptop>
References: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
	<1315633296.23777.32.camel@Joe-Laptop>
Date: Sat, 10 Sep 2011 17:40:19 +0100
Message-ID: <CANK3SE3KoWrz5B2EdhC01kW2f_GJrUK1HxxxcYiecb+8J1tscQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: et131x: Fix checkpatch whitespace warnings
From: Mark Einon <mark.einon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2011 06:41, Joe Perches <joe@perches.com> wrote:
> On Sat, 2011-09-03 at 12:49 +0100, Mark Einon wrote:
>> Some of my previous hacking attempts have not been following the rules.
>> All fixes either lines > 80 chars or whitespace corrections (spaces->tabs etc).
> []
>> diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
>> index ab85cb3..36f2168 100644
>> --- a/drivers/staging/et131x/et1310_mac.c
>> +++ b/drivers/staging/et131x/et1310_mac.c
>> @@ -191,7 +191,8 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
>>       cfg1 |= CFG1_RX_ENABLE | CFG1_TX_ENABLE | CFG1_TX_FLOW;
>>       /* Initialize loop back to off */
>>       cfg1 &= ~(CFG1_LOOPBACK | CFG1_RX_FLOW);
>> -     if (adapter->flowcontrol == FLOW_RXONLY || adapter->flowcontrol == FLOW_BOTH)
>> +     if (adapter->flowcontrol == FLOW_RXONLY ||
>> +                             adapter->flowcontrol == FLOW_BOTH)
>
> Especially in cases like this, it helps readability
> to align to open parenthesis like:
>
>        if (adapter->flowcontrol == FLOW_RXONLY ||
>            adapter->flowcontrol == FLOW_BOTH)
>

Thanks, noted. I'll bear it in mind for next time...

> []
>> @@ -641,7 +641,8 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
>>                * they point to
>>                */
>>               do {
>> -                     desc = (struct tx_desc *)(adapter->tx_ring.tx_desc_ring +
>> +                     desc = (struct tx_desc *)
>> +                                 (adapter->tx_ring.tx_desc_ring +
>>                                               INDEX10(tcb->index_start));
>
> Isn't this an unnecessary cast?
> Perhaps it's better as:
>
>                        u32 i10 = INDEX10(tcb->index_start);
>
>                        desc = &adapter->tx_ring.tx_desc_ring[i10];

That sounds like a good idea. I'll add it to the list when I go
through the tx/rx code for the driver.

Cheers,

Mark
