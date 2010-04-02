Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0DBMST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:18:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53033 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0DBMSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <20100402072750.GA22952@localhost>
References: <cc557aab1003250606g6b4e3e7dgb1adfd46adc89124@mail.gmail.com>
	 <3d0408631003252040r70c54b2fm24d64b819c59c9c@mail.gmail.com>
	 <20100326040114.GA20717@localhost> <20100402072750.GA22952@localhost>
Date: Fri, 2 Apr 2010 15:18:04 +0300
Message-ID: <r2gcc557aab1004020518u5329383eh2bfaaf404fc5d8e2@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] readahead: fix NULL filp dereference
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       "Yan, Zheng" <yanzheng@21cn.com>,
       "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 10:27 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> The btrfs relocate_file_extent_cluster() calls us with NULL filp:
>
>  [ 4005.426805] BUG: unable to handle kernel NULL pointer dereference at 00000021
>  [ 4005.426818] IP: [<c109a130>] page_cache_sync_readahead+0x18/0x3e
>
> CC: Yan Zheng <yanzheng@21cn.com>
> Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>
> Andrew and Greg:
>
> This is an obvious correct bug fix for .34 and .33-stable,
> so I'm resending it directly to you without Kirill's confirmation.

Sorry.

Tested-by: Kirill A. Shutemov <kirill@shutemov.name>

> --- sound-2.6.orig/mm/readahead.c       2010-03-26 11:51:57.000000000 +0800
> +++ sound-2.6/mm/readahead.c    2010-03-26 11:52:11.000000000 +0800
> @@ -502,7 +502,7 @@ void page_cache_sync_readahead(struct ad
>                return;
>
>        /* be dumb */
> -       if (filp->f_mode & FMODE_RANDOM) {
> +       if (filp && (filp->f_mode & FMODE_RANDOM)) {
>                force_page_cache_readahead(mapping, filp, offset, req_size);
>                return;
>        }
>
