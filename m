Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2HZJMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:12:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44234 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab2HZJMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120826090447.GA11098@localhost>
References: <20120826090447.GA11098@localhost>
Date: Sun, 26 Aug 2012 14:42:12 +0530
Message-ID: <CAHdPZaNs99QLOD=-QeUvFj5soSJMZCPU24V=5QXuVWx0r1jC5g@mail.gmail.com>
Subject: Re: fs/ntfs/super.c:2717:1-14: alloc with no test
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Anton Altaparmakov <anton@tuxera.com>, kernel-janitors@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 2:34 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> Hi Anton,
>
> FYI, coccinelle warns about
>
> fs/ntfs/super.c:2717:1-14: alloc with no test, possible model on line 2718
>
> vim +2717 fs/ntfs/super.c
>   2714          sb->s_flags |= MS_RDONLY;
>   2715  #endif /* ! NTFS_RW */
>   2716          /* Allocate a new ntfs_volume and place it in sb->s_fs_info. */
>> 2717          sb->s_fs_info = kmalloc(sizeof(ntfs_volume), GFP_NOFS);

That's i think a false alarm.

>   2718          vol = NTFS_SB(sb);

The NTFS_SB(buf) {
      buf->s_fs_info;
 }

so we are validating the allocated pointer s_fs_info.

correct me if i am wrong.

Thanks,

>   2719          if (!vol) {
>   2720                  if (!silent)
>
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
