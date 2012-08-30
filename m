Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2H3Gj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 02:39:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50644 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2H3Gj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 02:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <1346309023.2848.531.camel@sauron.fi.intel.com>
References: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
	<1346001700-26895-3-git-send-email-shijie8@gmail.com>
	<1346309023.2848.531.camel@sauron.fi.intel.com>
Date: Thu, 30 Aug 2012 14:39:55 +0800
Message-ID: <CAMiH66HaRG--3bC9HCfNu7S_WWKWx_COEuJdtgmBTNbdYdVt8Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] mtd: cmdlinepart: fix the wrong partitions number
 when truncating occurs
From: Huang Shijie <shijie8@gmail.com>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, shmulik.ladkani@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 2:43 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Sun, 2012-08-26 at 13:21 -0400, Huang Shijie wrote:
>> This patch is based on the assumption that all the partitions are
>> in the right offset order.
>>
>> Assume we have a 1GB(8Gb) nand chip, and we set the partitions
>> in the command line like this:
>>     #gpmi-nand:100m(boot),100m(kernel),1g(rootfs)
>>
>> In this case, the partition truncating occurs. The current code will
>> get the following result:
>>
>>      ----------------------------------
>>       root@freescale ~$ cat /proc/mtd
>>       dev:    size   erasesize  name
>>       mtd0: 06400000 00040000 "boot"
>>       mtd1: 06400000 00040000 "kernel"
>>      ----------------------------------
>>
>> It is obvious that we lost the truncated partition `rootfs` which should
>> be 824M in this case.
>>
>> Why? The old code sets the wrong partitions number when the truncating
>> occurs. This patch fixes it. Alao add a `break` to shortcut the code in this
>> case.
>>
>> After apply this patch, the result becomes:
>>      ----------------------------------
>>       root@freescale ~$ cat /proc/mtd
>>       dev:    size   erasesize  name
>>       mtd0: 06400000 00040000 "boot"
>>       mtd1: 06400000 00040000 "kernel"
>>       mtd2: 33800000 00040000 "rootfs"
>>      ----------------------------------
>>
>> We get the right result.
>>
>> Signed-off-by: Huang Shijie <shijie8@gmail.com>
>
> Should this have CC to -stable?

It's ok to CC to stable.


thanks
Huang Shijie
>
> --
> Best Regards,
> Artem Bityutskiy
