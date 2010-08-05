Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab0HEO3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:29:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867Ab0HEO3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:29:20 -0400
Message-ID: <4C5ACAAD.1030305@kernel.org>
Date: Thu, 05 Aug 2010 16:29:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v3 3/3] init: add support for root devices specified by
 	partition UUID
References: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com>	<1280946126-19587-3-git-send-email-wad@chromium.org>	<4C5A98A0.4030208@kernel.org> <AANLkTikUp_gz1FJW2meK9+Ow4bKX-8jVrvvSDVv=mYpQ@mail.gmail.com>
In-Reply-To: <AANLkTikUp_gz1FJW2meK9+Ow4bKX-8jVrvvSDVv=mYpQ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 14:28:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/05/2010 04:26 PM, Will Drewry wrote:
> On Thu, Aug 5, 2010 at 5:55 AM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> On 08/04/2010 08:22 PM, Will Drewry wrote:
>>> @@ -642,6 +642,7 @@ void __init printk_all_partitions(void)
>>>               struct hd_struct *part;
>>>               char name_buf[BDEVNAME_SIZE];
>>>               char devt_buf[BDEVT_SIZE];
>>> +             u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
>>>
>>>               /*
>>>                * Don't show empty devices or things that have been
>>> @@ -660,10 +661,14 @@ void __init printk_all_partitions(void)
>>>               while ((part = disk_part_iter_next(&piter))) {
>>>                       bool is_part0 = part == &disk->part0;
>>>
>>> -                     printk("%s%s %10llu %s", is_part0 ? "" : "  ",
>>> +                     uuid[0] = 0;
>>> +                     if (part->info)
>>> +                             part_unpack_uuid(part->info->uuid, uuid);
>>> +
>>> +                     printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
>>>                              bdevt_str(part_devt(part), devt_buf),
>>>                              (unsigned long long)part->nr_sects >> 1,
>>> -                            disk_name(disk, part->partno, name_buf));
>>> +                            disk_name(disk, part->partno, name_buf), uuid);
>>
>> Hmmm... I'm a bit worried about this.  This might break userspace
>> tools.  I think it would be better to export it via sysfs.
> 
> Cool - I'm happy to drop that part from the patch.  I was more
> following the spirit of the comment around making it easy for a user
> to figure out what went wrong (e.g., wrong uuid) if they don't have a
> root, but if there are tools parsing that output, I'd rather not break
> them!

Oh, forget about what I said.  For some reason I thought the above
code was for /proc/partitions.  :-)

Thanks.

-- 
tejun
