Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1K2ACa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:02:30 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37601 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1K2AC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:02:29 -0500
MIME-Version: 1.0
In-Reply-To: <20111128154801.05f7c199.akpm@linux-foundation.org>
References: <1322125938-6944-2-git-send-email-dg77.kim@samsung.com>
	<1322125938-6944-3-git-send-email-dg77.kim@samsung.com>
	<20111128154801.05f7c199.akpm@linux-foundation.org>
Date: Tue, 29 Nov 2011 09:02:28 +0900
X-Google-Sender-Auth: zEvygOSx8HSk6SBX5oD5jiBzg4g
Message-ID: <CAH9JG2U7zFK-DnvqFEaKetSr_cpfqqfy-MKWAX+w7Wr=U39k2g@mail.gmail.com>
Subject: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/11, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 24 Nov 2011 18:12:18 +0900
> Donggeun Kim <dg77.kim@samsung.com> wrote:
>
>> The MUIC function in MAX8997 device can be used as
>> a USB port detector and switch.
>> This patch supports the MUIC feature of MAX8997.
>>
>> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Samuel, can you please merge this if/when it's ready?

Thank you!

FYI: Now we proposed the new subsystem to handle the external
connector, "multistate switch'.
and this drivers is the candidate one for this subsystem.
Previous time, we sent the fsa9480, micro USB switch. this driver is
also covered at multistate switch framework.

Thank you,
Kyungmin Park
>
>>
>> ...
>>
>> +static irqreturn_t max8997_muic_irq_handler(int irq, void *data)
>> +{
>> +	struct max8997_muic_info *info = data;
>> +
>> +	dev_dbg(info->dev, "irq:%d\n", irq);
>> +	info->irq = irq;
>> +
>> +	schedule_work(&info->irq_work);
>> +
>> +	return IRQ_HANDLED;
>> +}
>
> The code does schedule_work() but I see no flush_work().  Is it
> possible for the work to still be pending after device shutdown, or
> even after rmmod?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
