Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1I1NuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:50:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57292 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1I1NuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZM-F-E_RUu4JTd-1J8UeQWXiekBcnMf7Jp7m07B8SYVQ@mail.gmail.com>
References: <1316840820-2014-1-git-send-email-linkinjeon@gmail.com>
	<CACRpkdZM-F-E_RUu4JTd-1J8UeQWXiekBcnMf7Jp7m07B8SYVQ@mail.gmail.com>
Date: Wed, 28 Sep 2011 22:50:17 +0900
Message-ID: <CAKYAXd-=EaG02N6f2VWO0ZNCshWp6swiT-WwpOV-p+cTDL7wwA@mail.gmail.com>
Subject: Re: [PATCH v2] mmc : general purpose partition support.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        awarkentin@vmware.com, adrian.hunter@intel.com,
        james_p_freyensee@linux.intel.com, sebras@gmail.com,
        Ulf Hansson <Ulf.Hansson@stericsson.com>,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>, johan.rudholm@stericsson.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/28 Linus Walleij <linus.walleij@linaro.org>:
> On Sat, Sep 24, 2011 at 7:07 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>
>> It allows gerneral purpose partitions in MMC Device.
>> And I try to simpliy make mmc_blk_alloc_parts using mmc_part structure suggested by Andrei Warkentin.
>> After patching, we can see general purpose partitions like this.
>>> cat /proc/partitions
>>          179 0 847872 mmcblk0
>>          179 192 4096 mmcblk0gp4
>>          179 160 4096 mmcblk0gp3
>>          179 128 4096 mmcblk0gp2
>>          179 96  1052672 mmcblk0gp1
>
> We notice there are 32 minors between 128 and 96,
> how are these allocated?
You can insert maximum minors in menuconfig. I set to 32.
>
>>          179 64  1024 mmcblk0boot1
>>          179 32  1024 mmcblk0boot0
>
> Does this mean that each GP-partition can contain an MBR and thus several
> subpartitions so we get things like:
>
> mmcblk0gp1p1, mmcblk0gp1p2...
>
>
Yes, We can divide dos partitions(included MBR) using fdisk like your
words(mmcblk0gp1p1, mmcblk0gp1p2...)

> Yours,
> Linus Walleij
>
