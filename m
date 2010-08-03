Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab0HCVyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:54:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60998 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0HCVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:54:49 -0400
MIME-Version: 1.0
In-Reply-To: <1280871336-31046-2-git-send-email-wad@chromium.org>
References: <AANLkTin3+LfXOpW5MsPSgs_5Z0UFnQTwBAXSocrU1Xs8@mail.gmail.com> 
	<1280871336-31046-2-git-send-email-wad@chromium.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 3 Aug 2010 23:54:33 +0200
Message-ID: <AANLkTimX-5v4qNeK1DD84n8z6-jpq8DSvCa5PepuhgM5@mail.gmail.com>
Subject: Re: [PATCH 2/2] genhd, efi: add efi partition metadata to hd_structs
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 23:35, Will Drewry <wad@chromium.org> wrote:
> This change extends the partition_meta_info structure to
> support EFI GPT-specific metadata and ensures that data
> is copied in on partition scanning.
>
> Adding this information would make it possible to identify a
> partition by GUID using something like disk_part_iter_*(),
> calls that make hd_struct accessible, or even class_find_device.

Wow, you are fast. :) Sounds and looks good to me.

I guess we should assign the meta structure only after all values are
filled in? Otherwise we could get partial reads from a possible user?

Did you already test to put a lookup-call to the in-kernel mounter, if
we use some special partition table uuid identifier for root=? That
would be nice to see, if all that works as expected, and we can get to
the data we collect.

Kay
