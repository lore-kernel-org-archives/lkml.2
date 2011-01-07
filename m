Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1AGPNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:13:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62633 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1AGPNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:13:44 -0500
MIME-Version: 1.0
In-Reply-To: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
References: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 7 Jan 2011 16:13:27 +0100
Message-ID: <AANLkTindW3TnuP8VA0co-bLT7r2M-jrxTR_sYYQj1rE9@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/2] init: Add support for root devices to be
 specified by partition name
To: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 12:42, Kirill Smelkov <kirr@landau.phys.spbu.ru> wrote:
>  [ In follow-up to b5af921e ]
>
> Besides GUIDs, there are also partition names stored in an EFI GPT
> partition table. So let's add support for root to be located not only by
> GUID, but also by partition names, like this:
>
>    root=PARTNAME=<partition-name>

Are you sure about this? What's your use case?

Generally, we really don't recommend ever to use any simple labels for
critical stuff -- not from filesystems, not from partitions.

I know that some distros did that, but this is pretty misguided, and I
think, should not be extended to any new facility, unless there is a
good use case for that.

Labels are not unique and in the general case absolutely not useful to
uniquely identify data on a disk. They only make sense for humans, or
interfaces that visualize things -- they should usually not be used in
any environment that reliably needs to identify a certain partition.
We have the uuids  for a reason.

Kay
