Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0KDWot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:44:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34796 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0KDWoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FzO7ca7lpoaOzGKRCrptXxBzh7NF/185ZKtImFMIlcbhjoKka17w7bpeCNPySvtHy/
         bLx5mmBsEHPtZAC9WmTmj6johpmCVXrHkTGnXjITOS5kpvJCHbgS45CHK2cZ5meFTDiP
         qlcDuaXsM7mjRU1oMASvqy7H4hMmJHRe0EyUg=
MIME-Version: 1.0
In-Reply-To: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
References: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 4 Nov 2010 18:44:26 -0400
Message-ID: <AANLkTikkAL-ZzxLfa+POoyv4qCE0LUq1h+nfE2_Bn7Ji@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs: Small refactoring of the code in ext4 2.6.37-rc1
To: andre@bsrsoft.com.br
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/4 André Luis Pereira dos Santos - BSRSoft <andre@bsrsoft.com.br>:
> From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
>
> Hi.
> Small refactoring of the code in order to make minor enhancements to critical areas.
> The notation x + 1 has been replaced by more efficient notation x + +.
>
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> ---
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> --- linux-2.6.37-rc1/fs/ext4/extents.c  2010-11-01 09:54:12.000000000 -0200
> +++ linux-2.6.37-rc1-patched/fs/ext4/extents.c  2010-11-04 19:54:26.000000000 -0200
> @@ -555,9 +555,9 @@ ext4_ext_binsearch(struct inode *inode,
>        while (l <= r) {
>                m = l + (r - l) / 2;
>                if (block < le32_to_cpu(m->ee_block))
> -                       r = m - 1;
> +                       r = m--;
>                else
> -                       l = m + 1;
> +                       l = m++;
>                ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ee_block),
>                                m, le32_to_cpu(m->ee_block),
>                                r, le32_to_cpu(r->ee_block));
> @@ -1557,7 +1557,7 @@ static int ext4_ext_try_to_merge(struct
>                if (ext4_ext_is_uninitialized(ex))
>                        uninitialized = 1;
>                ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
> -                               + ext4_ext_get_actual_len(ex + 1));
> +                               + ext4_ext_get_actual_len(ex++));
>                if (uninitialized)
>                        ext4_ext_mark_uninitialized(ex);

But

                   r = m - 1;
is not equivalent to
                   r = m--;

At a minimum your code no longer passes the same value to of m to ext_debug.

NAK

Greg
