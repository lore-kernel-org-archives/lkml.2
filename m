Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2EUMAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:00:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33338 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2EUMAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:00:00 -0400
MIME-Version: 1.0
In-Reply-To: <1337528060.4396.0@oscar>
References: <1337520203-29147-3-git-send-email-akinobu.mita@gmail.com>
	<1337528060.4396.0@oscar>
Date: Mon, 21 May 2012 20:59:59 +0900
Message-ID: <CAC5umygC0q03_fPc-bF66whusw=ieXv_5A3hOniMs5=MRd7BMw@mail.gmail.com>
Subject: Re: [PATCH 03/10] qnx4fs: use memweight()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Anders Larsen <al@alarsen.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/21 Anders Larsen <al@alarsen.net>:

>> @@ -44,13 +27,16 @@ unsigned long qnx4_count_free_blocks(struct
>> super_block *sb)
>>        struct buffer_head *bh;
>>
>>        while (total < size) {
>> +               int bytes = min(size - total, QNX4_BLOCK_SIZE);
>> +
>>                if ((bh = sb_bread(sb, start + offset)) == NULL) {
>>                        printk(KERN_ERR "qnx4: I/O error in counting free
>> blocks\n");
>>                        break;
>>                }
>> -               count_bits(bh->b_data, size - total, &total_free);
>> +               total_free += bytes * BITS_PER_BYTE-
>
>
> due to the missing whitespace after the macro I had to read that statement
> three times to comprehend it (which was probably good, since that's the beef
> ;)

Oh, checkpatch.pl also couldn't detect it.

>> +                               memweight(bh->b_data, bytes);
>>                brelse(bh);
>> -               total += QNX4_BLOCK_SIZE;
>> +               total += bytes;
>>                offset++;
>>        }
>
>
> Other than that,
> Acked-by: Anders Larsen <al@alarsen.net>

Thanks.
