Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2HZHwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 03:52:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46915 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2HZHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 03:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120825123149.3fafa4f4@halley>
References: <1345925210-7500-1-git-send-email-shijie8@gmail.com>
	<20120825123149.3fafa4f4@halley>
Date: Sun, 26 Aug 2012 03:52:12 -0400
Message-ID: <CAMiH66GXKPDsF0D5OOhdkBuSH-RhBUUQhM2B6bDqe2nc25YzOA@mail.gmail.com>
Subject: Re: [PATCH v2] mtd: cmdlinepart: fix the wrong check condition
From: Huang Shijie <shijie8@gmail.com>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 5:31 AM, Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
> Hi Huang, Artem,
>
> On Sat, 25 Aug 2012 16:06:50 -0400 Huang Shijie <shijie8@gmail.com> wrote:
>> diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
>> index fc960a3..216d751 100644
>> --- a/drivers/mtd/cmdlinepart.c
>> +++ b/drivers/mtd/cmdlinepart.c
>> @@ -322,13 +322,16 @@ static int parse_cmdline_partitions(struct mtd_info *master,
>>       struct cmdline_mtd_partition *part;
>>       const char *mtd_id = master->name;
>>
>> +     if (!mtd_id)
>> +             return 0;
>> +
>>       /* parse command line */
>>       if (!cmdline_parsed)
>>               mtdpart_setup_real(cmdline);
>>
>>       for(part = partitions; part; part = part->next)
>>       {
>> -             if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
>> +             if (!strcmp(part->mtd_id, mtd_id))
>>               {
>>                       for(i = 0, offset = 0; i < part->num_parts; i++)
>>                       {
>
> This changes the behavior of cmdling parsing, which might affect users
> expecting the old behavior.
>
> According to the remark above 'parse_cmdline_partitions':
>
>  * It returns partitions for the requested mtd device, or
>  * the first one in the chain if a NULL mtd_id is passed in.
>
> I think the purpose of a NULL 'mtd_id' was to support simple systems
> where there's a single driver and a single chip.
> The driver could be dumb, not specifying its 'mtd_info->name'
> (thus, a NULL mtd_id is passed).
>
> In this case, since the system is simply configured (one driver, one
> chip), 'parse_cmdline_partitions' simply disregards the "mtd-id" name
> specified in the cmdline string, allowing the user to present some
> arbitrary string there.
>
> I quite remember seeing this pattern somewhere in the past, I don't know
> if it's still used, though.
>
thanks for the detail explanation.


> Obviously if you have many drivers (and many chips) in a system, that
> won't work; the drivers must initialize 'mtd_info->name' and the user
> should present a cmdline that has explicit 'mtd-id's.
>
> So question is, would we like to prohibit NULL mtd-id?

I prefer to prohibit the NULL mtd-id. The code looks strange enough.


>
> If so, we must make sure all drivers are properly assigning their
> 'mtd_info->name', and all users correctly specifying 'mtd-id' in their
> "mtdparts" cmdline strings.
yes. I agree that all the driver should set the mtd_info->name properly.

Best Regards
Huang Shijie

>
> Regards,
> Shmulik
