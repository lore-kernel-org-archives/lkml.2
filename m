Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2HYJ1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 05:27:00 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44125 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2HYJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 05:26:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120825120231.73577d6a@halley>
References: <1345904767-23011-1-git-send-email-shijie8@gmail.com>
	<20120825120231.73577d6a@halley>
Date: Sat, 25 Aug 2012 05:26:51 -0400
Message-ID: <CAMiH66HyfNEzEHGyZUcLJ_01PNVHqA44fjAqXsyM2c-HHms8hQ@mail.gmail.com>
Subject: Re: [PATCH v2] mtd: cmdlinepart: fix the wrong partitions number when
 truncating occurs
From: Huang Shijie <shijie8@gmail.com>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 5:02 AM, Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
> Hi Huang,
>
> On Sat, 25 Aug 2012 10:26:07 -0400 Huang Shijie <shijie8@gmail.com> wrote:
>> diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
>> index 4558e0f..fc960a3 100644
>> --- a/drivers/mtd/cmdlinepart.c
>> +++ b/drivers/mtd/cmdlinepart.c
>> @@ -344,7 +344,8 @@ static int parse_cmdline_partitions(struct mtd_info *master,
>>                                              "%s: partitioning exceeds flash size, truncating\n",
>>                                              part->mtd_id);
>>                                       part->parts[i].size = master->size - offset;
>> -                                     part->num_parts = i;
>> +                                     part->num_parts = i + 1;
>> +                                     break;
>
> Your analysis seems right, but let me offer an alternative approach.
>
> I would simply:
>
> -                                       part->num_parts = i;
your code does not wors in such kernel command line(also with the 1GB
nand chip):
#gpmi-nand:100m(root),100m(kernel),1g(rootfs),1g(user),-(rest)

For you see, we must keep the code robust enough. It should passes all
the possible kernel command lines.




>
> (and not replace it with anything).
>
> The specified cmdline partitions might not be ordered (according to
> start offset), so next partition specified after the truncated one might
> define a partition at the beginning of the device, which is okay
> (regardless the truncation of current partition).
could you please give me an example of this specified cmdline?

I can test it.

Best Regards
Huang Shijie

>
> Your patch skips the definitions of next partitions, which can be legit.
>
> I agree specifying "unsorted" partitions is not commonly used (and it
> might make no sense when using the "remaining" syntax), but it is legit
> to define all partitions _explicitly_ with their size@offset in an
> unordered fashion.
>
> Regards,
> Shmulik
