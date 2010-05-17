Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0EQGKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:10:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37187 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0EQGKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O9/INm5ox08k4LFwG76FJxLSdXgDhKy4tb2z4+YsX5dRNu32igUrPAAsZloi3cQ85d
         Ct03UMkpMWYHLitHOQ9y5ZVBCKmvzpDfGyjvAbtiZ6qP/8C4A2uPV7TyflMYlwb8DlvD
         LkXnTOkF9o8AKitiFzs7IfgwBTP474IgzrYCw=
MIME-Version: 1.0
In-Reply-To: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
References: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
Date: Mon, 17 May 2010 09:10:41 +0300
X-Google-Sender-Auth: RCFKShR0ExyjB0rMDxLV9j345tg
Message-ID: <AANLkTinopOldGl3K648tnwmtMT3KhERIW8grokd45O3C@mail.gmail.com>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory 
	(v2 resend)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, hughd@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 8:32 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> Resending as Greg wanted.
>
> (tested on mainline but should apply to linux-next cleanly)
>
>
>  * Changelog: v2 vs initial patches
>   - directly add swap free callback to block_device_operations
>     instead of using 'notifiers' for various swap events.
>
> ramzswap driver creates RAM based block devices which can be
> used (only) as swap disks. Pages swapped to these disks are
> compressed and stored in memory itself.
>
> However, these devices do not get any notification when a swap
> slot is freed (swap_map[i] reaches 0). So, we cannot free memory
> allocated corresponding to this swap slot. Such stale data can
> quickly accumulate in (compressed) memory defeating the whole
> purpose of such devices.
>
> To overcome this problem, we now add a callback in struct
> block_device_operations which is called as soon as a swap
> slot is freed.
>
> Nitin Gupta (3):
>  Add flag to identify block swap devices
>  Add swap slot free callback to block_device_operations
>  ramzswap: Handler for swap slot free callback
>
>  drivers/staging/ramzswap/TODO           |    5 -----
>  drivers/staging/ramzswap/ramzswap_drv.c |   22 +++++++++++++---------
>  include/linux/blkdev.h                  |    2 ++
>  include/linux/swap.h                    |    1 +
>  mm/swapfile.c                           |    5 +++++
>  5 files changed, 21 insertions(+), 14 deletions(-)
>  delete mode 100644 drivers/staging/ramzswap/TODO

Nitin, please retain ACKs when resending patches.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

for the whole series.
