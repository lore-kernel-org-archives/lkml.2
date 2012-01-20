Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2ATFj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 00:39:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53426 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2ATFj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 00:39:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2VNSUNYAqd9MUawf4a5Q6HfjE07KOOZ5dkYnzzuzc0KrA@mail.gmail.com>
References: <002501ccd728$baca1010$305e3030$%jun@samsung.com>
	<CAH9JG2VNSUNYAqd9MUawf4a5Q6HfjE07KOOZ5dkYnzzuzc0KrA@mail.gmail.com>
Date: Fri, 20 Jan 2012 14:39:54 +0900
Message-ID: <CAKYAXd8XqmAdODx0sWviv1egviEAEVu_SOsy8GKBTcTzjAQ2oA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] mmc: core: Support packed command feature of eMMC4.5
From: Namjae Jeon <linkinjeon@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Seungwon,

Would you show improved performance measurement
result(read/write,seq,ran) when using packed cmd ?

Thanks.


2012/1/20 Kyungmin Park <kmpark@infradead.org>:
> Hi,
>
> FYI: we get performance gain using packed command at write. however in
> case of small size read, there are some performance drop since
> protocol overhead.
> In normal case, read command uses read operation only, but in case of
> packed read. It sends the command to eMMC and read it.
> Anyway it's good feature for eMMC v4.5.
>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> On 1/20/12, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> This patch-set adds support of packed command feature
>> for eMMC4.5 devices.
>>
>> Changes in v3:
>>       - Add a variable member in mmc_host for minimum number of packed entries.
>>         This value can be overrided by host.
>>       - Fix a handling of error sequence.
>>
>> Changes in v2:
>>       - Fix the packed read sequence and error handling.
>>       - Apply checking the exception status for all cases with
>>         the comments from Maya Erez and Sahitya Tummala.
>>       - Fix preparing the packed list with the comment from Maya Erez and
>> Venkatraman.
>>
>>
>> Seungwon Jeon (2):
>>       mmc: core: Add packed command feature of eMMC4.5
>>       mmc: core: Support packed command for eMMC4.5 device
>>
>>  drivers/mmc/card/block.c   |  469
>> +++++++++++++++++++++++++++++++++++++++++---
>>  drivers/mmc/card/queue.c   |   48 +++++-
>>  drivers/mmc/card/queue.h   |   13 ++
>>  drivers/mmc/core/host.c    |    2 +
>>  drivers/mmc/core/mmc.c     |   24 +++
>>  drivers/mmc/core/mmc_ops.c |    1 +
>>  include/linux/mmc/card.h   |    3 +
>>  include/linux/mmc/core.h   |    3 +
>>  include/linux/mmc/host.h   |    4 +
>>  include/linux/mmc/mmc.h    |   15 ++
>>  10 files changed, 555 insertions(+), 27 deletions(-)
>>
>> Best regards,
>> Seungwon Jeon.
>> --
>> 1.7.2.3
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
