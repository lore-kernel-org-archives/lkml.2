Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab0HCW1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:27:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48117 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab0HCW1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:27:05 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimX-5v4qNeK1DD84n8z6-jpq8DSvCa5PepuhgM5@mail.gmail.com>
References: <AANLkTin3+LfXOpW5MsPSgs_5Z0UFnQTwBAXSocrU1Xs8@mail.gmail.com>
	<1280871336-31046-2-git-send-email-wad@chromium.org>
	<AANLkTimX-5v4qNeK1DD84n8z6-jpq8DSvCa5PepuhgM5@mail.gmail.com>
Date: Tue, 3 Aug 2010 17:27:04 -0500
Message-ID: <AANLkTik4DRO3685HG8-Hkp3=s=vinUdTQ=votQuf4-8N@mail.gmail.com>
Subject: Re: [PATCH 2/2] genhd, efi: add efi partition metadata to hd_structs
From: Will Drewry <wad@chromium.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 4:54 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Aug 3, 2010 at 23:35, Will Drewry <wad@chromium.org> wrote:
>> This change extends the partition_meta_info structure to
>> support EFI GPT-specific metadata and ensures that data
>> is copied in on partition scanning.
>>
>> Adding this information would make it possible to identify a
>> partition by GUID using something like disk_part_iter_*(),
>> calls that make hd_struct accessible, or even class_find_device.
>
> Wow, you are fast. :) Sounds and looks good to me.

Thanks!

> I guess we should assign the meta structure only after all values are
> filled in? Otherwise we could get partial reads from a possible user?

In add_partition(), I don't think the partition itself is shared until
rcu_assign_pointer is called, and I don't think that parsed_partitions
is safe to be shared inside check.c, but perhaps that's a dangerous
assumption

I can certainly move the pointer assignment to occur after the data is
copied over since it shouldn't hurt anything.

> Did you already test to put a lookup-call to the in-kernel mounter, if
> we use some special partition table uuid identifier for root=? That
> would be nice to see, if all that works as expected, and we can get to
> the data we collect.

Not yet, but I'd like to have it working there (and in my
device-mapper target) as soon as possible.  Hopefully, I'll have that
done pretty soon and I'll repost the series inclusive of an init:
change.

Any preferences on the variable? I'll start with your example of
PARTUUID=, but that follows the initramfs model (UUID=) and not the
existing magic root devices (/dev/nfs, /dev/ram).
/dev/by-part-uuid/XXX... doesn't seem super-friendly though :)

cheers -
will
