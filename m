Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab1JGAjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 20:39:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54818 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1JGAjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 20:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <4E8DA415.8090007@russia.ru>
References: <4E8DA415.8090007@russia.ru>
Date: Thu, 6 Oct 2011 17:39:03 -0700
X-Google-Sender-Auth: dHiRnodUGDjNcu2OTMEfKPtLmf0
Message-ID: <CAA9_cmfSTgF5WxcAFMa+TgfN1166a=XZziToF1mSyP2LqX9ctQ@mail.gmail.com>
Subject: Re: BUG: spinlock lockup while performing FS operations
From: Dan Williams <dan.j.williams@intel.com>
To: =?KOI8-R?B?98HMxdLJyg==?= <paramonov@russia.ru>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org,
        axboe@kernel.dk, duaneg@dghda.com
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 5:50 AM, ˜¡Ã≈“…  <paramonov@russia.ru> wrote:
> Hi!
>
> Faced with this problem. There are RAID5, assembled by mdadm (/dev/md127),
> which is divided into 2 partitions (md127p1 and md127p2). In both reiserfs.
> The
> second partition is exported via NFS. Everything works, the array is intact
> and
> fully synchronized. SMART says disks are healthy. But when copy too many
> files
> all hangs and saves only the reset. After a reset of course runs fsck, and
> then
> synchronize the array.
>
> I have a brand new computer. Sleaze is not set. Motherboard gigabyte
> 870-UD3,
> Power Supply FSP 700W, memory 16Gb Kingston, CPU Phenom II X6 1090T.
>
> I öreported an error öon öbugs.gentoo.org:
> https://bugs.gentoo.org/show_bug.cgi?id=385047
> Was öcompiling a custom kernel öwith support for ödebugging and ödebug
> messages are öreceived.
> Duane Griffin öthen ösent me öupstream.
>
> Now I have have BUG spinlock lockup on screen:
>
> Nov 26 13:34:46 localhost kernel: BUG: spinlock lockup on CPU#2, mc/7609,
> ffff880419c37200
> Oct ö4 15:55:50 localhost kernel: BUG: spinlock lockup on CPU#3,
> flush-9:127/2391, ffff880419c37200
>
> Full log from /var/log/messages:

This is the full log?  I see other /var/log/messages excerpts from the
gentoo bugzilla.  Just wondering if there were any other warnings in
the log that precede the failure?

Can you attach the kernel configuration file to that bugzilla as well.

It sounds like you can reproduce it reliably.  Is this a recent
upgrade, or a new install?  If it was working before an upgrade we
might be able to bisect.

--
Dan
