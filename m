Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab0HDOqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:46:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44891 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab0HDOqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <4C591D65.4070508@kernel.org>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
	<1280887483-2979-1-git-send-email-wad@chromium.org>
	<4C591D65.4070508@kernel.org>
Date: Wed, 4 Aug 2010 09:46:00 -0500
Message-ID: <AANLkTinqNuKkvk8NPpUyr5VZuNmgLJzju9N0KTPvPdxn@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] block, partition: add partition_meta_info to 
	hd_struct
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

On Wed, Aug 4, 2010 at 2:57 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 08/04/2010 04:04 AM, Will Drewry wrote:
>> This changes adds a partition_meta_info struct which itself contains a
>> union of structures that provide partition table specific metadata.
>>
>> This change leaves the union empty. The subsequent patch includes an
>> implementation for CONFIG_EFI_PARTITION-based metadata.
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>
> Generally looks good to me.
>
>>  /*
>>   * add_gd_partition adds a partitions details to the devices partition
>>   * description.
>> @@ -12,6 +13,7 @@ struct parsed_partitions {
>>               sector_t from;
>>               sector_t size;
>>               int flags;
>> +             struct partition_meta_info *info;
>>       } parts[DISK_MAX_PARTS];
>
> But you can just embed the structure here.  It's a temp data structure
> to make things easier for individual partition scan code.  There's no
> need to save bytes.

Great - that'll simplify the code more.

Thanks!
