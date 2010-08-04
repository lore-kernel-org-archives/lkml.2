Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0HDH5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:57:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:46387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab0HDH5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:57:21 -0400
Message-ID: <4C591D65.4070508@kernel.org>
Date: Wed, 04 Aug 2010 09:57:25 +0200
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
Subject: Re: [PATCH v2 1/3] block, partition: add partition_meta_info to hd_struct
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com> <1280887483-2979-1-git-send-email-wad@chromium.org>
In-Reply-To: <1280887483-2979-1-git-send-email-wad@chromium.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 07:57:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/04/2010 04:04 AM, Will Drewry wrote:
> This changes adds a partition_meta_info struct which itself contains a
> union of structures that provide partition table specific metadata.
> 
> This change leaves the union empty. The subsequent patch includes an
> implementation for CONFIG_EFI_PARTITION-based metadata.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>

Generally looks good to me.

>  /*
>   * add_gd_partition adds a partitions details to the devices partition
>   * description.
> @@ -12,6 +13,7 @@ struct parsed_partitions {
>  		sector_t from;
>  		sector_t size;
>  		int flags;
> +		struct partition_meta_info *info;
>  	} parts[DISK_MAX_PARTS];

But you can just embed the structure here.  It's a temp data structure
to make things easier for individual partition scan code.  There's no
need to save bytes.

Thanks.

-- 
tejun
