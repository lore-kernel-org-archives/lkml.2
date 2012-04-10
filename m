Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab2DJVCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:02:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37985 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2DJVCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:02:42 -0400
MIME-Version: 1.0
In-Reply-To: <CABkLObr4Vyp9FwxfOquFjqnh1rEaLXNAzBV4SV-PO=UA4EC2vA@mail.gmail.com>
References: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com>
	<1333442836-9947-3-git-send-email-akinobu.mita@gmail.com>
	<CABkLObr4Vyp9FwxfOquFjqnh1rEaLXNAzBV4SV-PO=UA4EC2vA@mail.gmail.com>
Date: Wed, 11 Apr 2012 06:02:41 +0900
Message-ID: <CAC5umyhu0TRgLhv+bbqRbcfx-hK5pacFt0bYOmzX4gODHt4B-A@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm: davinci: use for_each_set_bit_from
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/11 Christian Riesch <christian.riesch@omicron.at>:

>> --- a/arch/arm/mach-davinci/dma.c
>> +++ b/arch/arm/mach-davinci/dma.c
>> @@ -557,9 +557,9 @@ static int reserve_contiguous_slots(int ctlr, unsigned
>> int id,
>>        if (i == edma_cc[ctlr]->num_slots)
>>                stop_slot = i;
>>
>> -       for (j = start_slot; j < stop_slot; j++)
>> -               if (test_bit(j, tmp_inuse))
>> -                       clear_bit(j, edma_cc[ctlr]->edma_inuse);
>> +       j = start_slot;
>> +       for_each_set_bit_from(j, tmp_inuse, stop_slot);
>
> Is the semicolon at the end of the line correct?

It's clearly a bug that I was going to introduce.  I'll fix and
resend it.

Thanks a lot.

>> +               clear_bit(j, edma_cc[ctlr]->edma_inuse);
>>
>>        if (count)
>>                return -EBUSY;
>> --
>> 1.7.4.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
