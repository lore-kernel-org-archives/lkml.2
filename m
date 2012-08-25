Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2HYLHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 07:07:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53278 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HYLHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 07:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120825124249.6aab8f9e@halley>
References: <1345904767-23011-1-git-send-email-shijie8@gmail.com>
	<20120825120231.73577d6a@halley>
	<CAMiH66HyfNEzEHGyZUcLJ_01PNVHqA44fjAqXsyM2c-HHms8hQ@mail.gmail.com>
	<20120825124249.6aab8f9e@halley>
Date: Sat, 25 Aug 2012 07:07:04 -0400
Message-ID: <CAMiH66GYZiEj10K-5yk93BybNPK265BKCQCVW0w+8N865ghz8g@mail.gmail.com>
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

On Sat, Aug 25, 2012 at 5:42 AM, Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
> On Sat, 25 Aug 2012 05:26:51 -0400 Huang Shijie <shijie8@gmail.com> wrote:
>> > The specified cmdline partitions might not be ordered (according to
>> > start offset), so next partition specified after the truncated one might
>> > define a partition at the beginning of the device, which is okay
>> > (regardless the truncation of current partition).
>> could you please give me an example of this specified cmdline?
>
> Assume we have a 1GB(8Gb) nand chip:
>   #gpmi-nand:1g@200m(rootfs),100m@0(boot),100m@100m(kernel)
>
> I am used to explicitly specify size@offset for all my parts.

thanks for this example.

I tested it just now.
The current code (without my patch) can not parse out none of the partitions.
It  directly stops at the first truncated `rootfs` partition.

I think i should send another patch to sort all the partitions.

thanks a lot.

Huang Shijie
