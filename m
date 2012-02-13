Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab2BMQWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:22:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65432 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab2BMQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:22:46 -0500
MIME-Version: 1.0
In-Reply-To: <1329006098-5454-4-git-send-email-andrea@betterlinux.com>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com> <1329006098-5454-4-git-send-email-andrea@betterlinux.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 13 Feb 2012 11:22:26 -0500
X-Google-Sender-Auth: Swh99qbykZLzXYvDf4qT1DnySAQ
Message-ID: <CAHGf_=qs8-nE6y6EzNYUzgjGo0sMP5zvCc3=GNZmHct6mPecqg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] fadvise: implement POSIX_FADV_NOREUSE
To: Andrea Righi <andrea@betterlinux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1DGMqRY002888

> @@ -1181,8 +1258,22 @@ page_ok:
>                 * When a sequential read accesses a page several times,
>                 * only mark it as accessed the first time.
>                 */
> -               if (prev_index != index || offset != prev_offset)
> -                       mark_page_accessed(page);
> +               if (prev_index != index || offset != prev_offset) {
> +                       int mode;
> +
> +                       mode = filemap_get_cache(mapping, index);
> +                       switch (mode) {
> +                       case FILEMAP_CACHE_NORMAL:
> +                               mark_page_accessed(page);
> +                               break;
> +                       case FILEMAP_CACHE_ONCE:
> +                               mark_page_usedonce(page);
> +                               break;
> +                       default:
> +                               WARN_ON_ONCE(1);
> +                               break;

Here is generic_file_read, right? Why don't you care write and page fault?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
