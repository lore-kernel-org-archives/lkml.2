Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1IWD46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 23:56:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1IWD44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 23:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <728441958.616721.1316748325054.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <1316705680-1940-1-git-send-email-linkinjeon@gmail.com>
	<728441958.616721.1316748325054.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Date: Fri, 23 Sep 2011 12:56:54 +0900
Message-ID: <CAKYAXd_B9111vCZXhow1pv+9QsUuZYhWZ6Sner8yV2qmOhVcgA@mail.gmail.com>
Subject: Re: [PATCH] mmc : general purpose partition support.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/23 Andrei Warkentin <awarkentin@vmware.com>:
> Hi Namjae,
>
> I scanned over your changes to enable GP partitions, and while I
> did not yet test your changes, they do appear to be ok.
>
> Please CC me on the next version of your patch so I can give
> it a spin and Ack on it.
>
> I do suggest at least thinking about ways to improve on this. Back
> when I added boot partition support, I already didn't like the fact
> that the block driver had to be aware of the eMMC partitions, with all
> the code duplication and such. By adding four more partitions,
> you've compounded the problem and now you have six pieces of
> code that really look the same.
>
> The core/mmc.c right now scans the size values and stores them
> in mmc_card, and the block driver is smart enough to know what
> to do with them. Why not make the block code generic at the expense
> of keeping an array of structures in mmc_card? The block driver
> would then just iterate over these and create the additional devices. The partition
> switch routine would then operate on these structures, and could then be pulled out
> of the block driver, making it simpler.
>
> Each physical partition could be described by something like -
> struct mmc_part {
>    unsigned int size;
>    unsigned int cookie;        /* for mmc, idx used in mmc_switch, part_type from current mmc_blk_data */
>    char name[DISK_NAME_LEN];
>    bool force_ro;              /* to make boot parts RO by default */
> };
>
> Just an idea. Clearly, if MMC grows by another 4-5 possible partitions, it's not
> realistic to be copy-pasting the same block of code, nor would it make sense
> if/when these types of devices support an arbitrary amount of physical partitions.
>
> Thanks,
> A
>

Okay, I understand what you want. I will try to make patch included
your suggestion again.
Thanks for your review.
