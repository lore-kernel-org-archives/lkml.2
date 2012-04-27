Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2D0BOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 21:14:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65005 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2D0BOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 21:14:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F998FDE.5020104@redhat.com>
References: <4F998FDE.5020104@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 26 Apr 2012 21:14:16 -0400
Message-ID: <CAHGf_=qLX7gofwHoSKpHLp7nvD6qJtHbmYzAR0UQ42JbfnYerw@mail.gmail.com>
Subject: Re: [PATCH -mm V3] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
To: lwoodman@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Christoph Lameter <cl@linux.com>, Motohiro Kosaki <mkosaki@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3R1EjBf018077

> @@ -1012,6 +1012,26 @@ int do_migrate_pages(struct mm_struct *mm,
>                int dest = 0;
>
>                for_each_node_mask(s, tmp) {
> +
> +                       /*
> +                        * do_migrate_pages() tries to maintain the
> +                        * relative node relationship of the pages
> +                        * established between threads and memory areas.
> +                        *
> +                        * However if the number of source nodes is not
> +                        * equal to the number of destination nodes we
> +                        * can not preserve this node relative relationship.
> +                        * In that case, skip copying memory from a node
> that
> +                        * is in the destination mask.
> +                        *
> +                        * Example: [2,3,4] -> [3,4,5] moves everything.
> +                        *                 [0-7] - > [3,4,5] moves only
> 0,1,2,6,7.
> +                        */
> +
> +                       if ((nodes_weight(*from_nodes) !=
> nodes_weight(*to_nodes)) &&
> +                                               (node_isset(s, *to_nodes)))
> +                               continue;
> +
>                        d = node_remap(s, *from_nodes, *to_nodes);
>                        if (s == d)
>                                continue;

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
