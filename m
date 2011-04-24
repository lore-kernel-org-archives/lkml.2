Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1DXFhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 01:37:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34711 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1DXFhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 01:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B6jM9QY37toZQTRrIlUsvd93PEefo0aNk29E3ZeuvRCxCR3XTbsHycWN1WXkgmBvp8
         u30RxlzOLiH87muKpIXKjmpLRxVnLhDQxZ3sXvyUEebyCB25iTyXkoFmbzdwZpFvudE1
         Ozd66LL+beIuLwIVIJYQ8D82BOCKbD1IR0lBw=
MIME-Version: 1.0
In-Reply-To: <1303604751-4980-1-git-send-email-minchan.kim@gmail.com>
References: <1303604751-4980-1-git-send-email-minchan.kim@gmail.com>
Date: Sun, 24 Apr 2011 14:37:12 +0900
Message-ID: <BANLkTinW7+14b-DSK80-3ujdgVjTbZ4KCQ@mail.gmail.com>
Subject: Re: [PATCH] Check PageActive when evictable page and unevicetable
 page race happen
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 9:25 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> In putback_lru_page, unevictable page can be changed into evictable
> 's one while we move it among lru. So we have checked it again and
> rescued it. But we don't check PageActive, again. It could add
> active page into inactive list so we can see the BUG in isolate_lru_pages.
> (But I didn't see any report because I think it's very subtle)
>
> It could happen in race that zap_pte_range's mark_page_accessed and
> putback_lru_page. It's subtle but could be possible.

Please Ignore this. I was confused.
The race never happens.


-- 
Kind regards,
Minchan Kim
