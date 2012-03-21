Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab2CUC3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 22:29:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65513 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2CUC3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 22:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEUDmDzGirBZRwKh5MTHvXX308JTHmmH_U0JfnPJkpvHJQ@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com>
	<alpine.LRH.2.02.1203181824590.24824@diagnostix.dwd.de>
	<CANejiEWeaF44Rbgt5jhf_bnafF4yoTTZAYsqoD2+greJ07c-_A@mail.gmail.com>
	<alpine.LRH.2.02.1203200839120.29880@diagnostix.dwd.de>
	<CANejiEVWbP53QVKZQBS2xKtaqdX6jdW_mjZxJ9q5=cxKNk6_dg@mail.gmail.com>
	<CANejiEUDmDzGirBZRwKh5MTHvXX308JTHmmH_U0JfnPJkpvHJQ@mail.gmail.com>
Date: Wed, 21 Mar 2012 02:29:21 +0000
Message-ID: <CADNH=7EfmNRXq1bSyuUcRGy-8ksfNhJuGnopubTRomq8-oSmJw@mail.gmail.com>
Subject: Re: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Shaohua Li <shli@kernel.org>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>, neilb@suse.de,
        axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2012 02:08, Shaohua Li <shli@kernel.org> wrote:
> 2012/3/20 Shaohua Li <shli@kernel.org>:
>> 2012/3/20 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>> Hello,
>>>
>>>
>>> On Tue, 20 Mar 2012, Shaohua Li wrote:
>>>
<snip>
> Thanks for the testing. The trace data is very helpful. In the intel
> SSD, trace data
> shows a discard request uses about 1 ~ 3 ms. The filesystem suffers from
> fragmentation too, so lots of small discard requests. When ext4 starts doing
> discard, it usually uses more than 1 minutes. That's too bad.
> If just looking one disk's trace data, there are some extra latencies between
> two discard requests. The combined trace data of two disks show the latency
> comes from waiting for another disk, so nothing abnormal. I thought we could
> do an optimization for this case in the future.
> So in summary, discard from the SSDs is slow. When your filesystem is
> fragmented, the performance will be terrible.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Many people prefer to have the filesystems mounted without discard,
then they run a TRIM command/script at night (or whenever the disk
isn't used very much). This way the TRIM commands don't slow down the
'overall' performance.

Mathias
