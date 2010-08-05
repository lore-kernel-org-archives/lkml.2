Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab0HETTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:19:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41376 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048Ab0HETTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <4C5ACAAD.1030305@kernel.org>
References: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com>
	<1280946126-19587-3-git-send-email-wad@chromium.org>
	<4C5A98A0.4030208@kernel.org>
	<AANLkTikUp_gz1FJW2meK9+Ow4bKX-8jVrvvSDVv=mYpQ@mail.gmail.com>
	<4C5ACAAD.1030305@kernel.org>
Date: Thu, 5 Aug 2010 14:19:16 -0500
Message-ID: <AANLkTinDEWsy6dn8om=pQYGqxCC4E_JbbVGuhRwdjfvj@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] init: add support for root devices specified by 
	partition UUID
From: Will Drewry <wad@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 9:29 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 08/05/2010 04:26 PM, Will Drewry wrote:
>> On Thu, Aug 5, 2010 at 5:55 AM, Tejun Heo <tj@kernel.org> wrote:
>>> Hello,
>>>
>>> On 08/04/2010 08:22 PM, Will Drewry wrote:
>>>> @@ -642,6 +642,7 @@ void __init printk_all_partitions(void)
>>>>               struct hd_struct *part;
>>>>               char name_buf[BDEVNAME_SIZE];
>>>>               char devt_buf[BDEVT_SIZE];
>>>> +             u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
>>>>
>>>>               /*
>>>>                * Don't show empty devices or things that have been
>>>> @@ -660,10 +661,14 @@ void __init printk_all_partitions(void)
>>>>               while ((part = disk_part_iter_next(&piter))) {
>>>>                       bool is_part0 = part == &disk->part0;
>>>>
>>>> -                     printk("%s%s %10llu %s", is_part0 ? "" : "  ",
>>>> +                     uuid[0] = 0;
>>>> +                     if (part->info)
>>>> +                             part_unpack_uuid(part->info->uuid, uuid);
>>>> +
>>>> +                     printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
>>>>                              bdevt_str(part_devt(part), devt_buf),
>>>>                              (unsigned long long)part->nr_sects >> 1,
>>>> -                            disk_name(disk, part->partno, name_buf));
>>>> +                            disk_name(disk, part->partno, name_buf), uuid);
>>>
>>> Hmmm... I'm a bit worried about this.  This might break userspace
>>> tools.  I think it would be better to export it via sysfs.
>>
>> Cool - I'm happy to drop that part from the patch.  I was more
>> following the spirit of the comment around making it easy for a user
>> to figure out what went wrong (e.g., wrong uuid) if they don't have a
>> root, but if there are tools parsing that output, I'd rather not break
>> them!
>
> Oh, forget about what I said.  For some reason I thought the above
> code was for /proc/partitions.  :-)

Cool - even better!

Thanks!
will
