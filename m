Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1KKXcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 18:32:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43010 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1KKXce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 18:32:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111111123957.7371.72792.stgit@zurg>
References: <20110729075837.12274.58405.stgit@localhost6>
	<20111111123957.7371.72792.stgit@zurg>
Date: Sat, 12 Nov 2011 08:32:33 +0900
Message-ID: <CAEwNFnA_ZGRyrtZ_LRzz66hmes8r+g+JEHHRAKsKWci7He-+5A@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: add free_hot_cold_page_list helper
From: Minchan Kim <minchan.kim@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pABNWlZc010217

On Fri, Nov 11, 2011 at 10:39 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> This patch adds helper free_hot_cold_page_list() to free list of 0-order pages.
> It frees pages directly from the list without temporary page-vector.
> It also calls trace_mm_pagevec_free() to simulate pagevec_free() behaviour.
>
> bloat-o-meter:
>
> add/remove: 1/1 grow/shrink: 1/3 up/down: 267/-295 (-28)
> function Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  old Â  Â  new Â  delta
> free_hot_cold_page_list Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â - Â  Â  264 Â  Â +264
> get_page_from_freelist Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â 2129 Â  Â 2132 Â  Â  Â +3
> __pagevec_free Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  243 Â  Â  239 Â  Â  Â -4
> split_free_page Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â 380 Â  Â  373 Â  Â  Â -7
> release_pages Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â 606 Â  Â  510 Â  Â  -96
> free_page_list Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  188 Â  Â  Â  - Â  Â -188
>
> v2: Remove list reinititialization.
> v3: Always free pages in reverse order.
> Â  Â The most recently added struct page, the most likely to be hot.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
