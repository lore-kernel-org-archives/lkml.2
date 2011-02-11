Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab1BKPye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:54:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64458 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab1BKPyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:54:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=idUdpM6rZJbWJzZrdKyfWvoobWh1rP3TbS2T6Nl1Pm+KQBJCScJllt3YdF0aJGymXQ
         D9vTeojK+9JSqpkuFeKi9nvPF55CbWwM70avSJxBzJ/VB7rWDAdSDRbwc8l9aXj8yK1z
         6lVks5jJYcLTHrPaXjQEN3iLhTAavmvMtfI+s=
MIME-Version: 1.0
In-Reply-To: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
References: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
Date: Fri, 11 Feb 2011 15:54:31 +0000
Message-ID: <AANLkTiknsmEpkA-+BQi0gxtf-B+ooit9ik=sfZZtvTSE@mail.gmail.com>
Subject: Re: 2.6.37: Multi-second I/O latency while untarring
From: Matt <jackdachef@gmail.com>
To: Andrew Lutomirski <andy@luto.us>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 3:08 PM, Andrew Lutomirski <andy@luto.us> wrote:
> As I type this, I have an ssh process running that's dumping data into
> a fifo at high speed (maybe 500Mbps) and a tar process that's
> untarring from the same fifo onto btrfs.  The btrfs fs is mounted -o
> space_cache,compress.  This machine has 8GB ram, 8 logical cores, and
> a fast (i7-2600) CPU, so it's not an issue with the machine struggling
> under load.
>
> Every few tens of seconds, my system stalls for several seconds.
> These stalls cause keyboard input to be lost, firefox to hang, etc.
>
> Setting tar's ionice priority to best effort / 7 or to idle makes no difference.
>
> ionice idle and queue_depth = 1 on the disk (a slow 2TB WD) also makes
> no difference.
>
> max_sectors_kb = 64 in addition to the above doesn't help either.
>
> latencytop shows regular instances of 2-7 *second* latency, variously
> in sync_page, start_transaction, btrfs_start_ordered_extent, and
> do_get_write_access (from jbd2 on my ext4 root partition).
>
> echo 3 >drop_caches gave me 7 GB free RAM.  I still had stalls when
> 4-5 GB were still free (so it shouldn't be a problem with important
> pages being evicted).
>
> In case it matters, all of my partitions are on LVM on dm-crypt, but
> this machine has AES-NI so the overhead from that should be minimal.
> In fact, overall CPU usage is only about 10%.
>
> What gives?  I thought this stuff was supposed to be better on modern kernels.
>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Andrew,

you could try the following patch to speed up dm-crypt:

https://patchwork.kernel.org/patch/365542/

I'm using it on top of a highly-patched 2.6.37 kernel

not sure if exactly that version was included in 2.6.38


there are some additional handles to speed up dm:

e.g. PCRYCONFIG_CRYPTO_PCRYPT=y

Regards

Matt
