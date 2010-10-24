Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009Ab0JXWwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 18:52:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45899 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0JXWwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UtJkBIpDnipZfbLb5EIuzG/PtAm4idiacBfRWB3lEHaSLWIiSnN55BfWjRsyEPFJJR
         Hrq6q8lx6I5tOFndbTVxUsq5BvqKpjQQtE0Dzv0E9U6UjMZTKQH7iB40zYL3viLcrfPY
         jlZsS6HNkHLEukvr/YPRZTe5uML4ZjBaYH8rc=
MIME-Version: 1.0
In-Reply-To: <1287787911-4257-1-git-send-email-msb@chromium.org>
References: <1287787911-4257-1-git-send-email-msb@chromium.org>
Date: Mon, 25 Oct 2010 07:52:47 +0900
Message-ID: <AANLkTinWp-M4S5EXz6-xJvHAnzdk96_5+d2OJVjCycsm@mail.gmail.com>
Subject: Re: [PATCH] vmscan: move referenced VM_EXEC pages to active list
From: Minchan Kim <minchan.kim@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 7:51 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
> In commit 64574746, "vmscan: detect mapped file pages used only once",
> Johannes Weiner, added logic to page_check_reference to cycle again
> used once pages.
>
> In commit 8cab4754, "vmscan: make mapped executable pages the first
> class citizen", Wu Fengguang, added logic to shrink_active_list which
> protects file-backed VM_EXEC pages by keeping them in the active_list if
> they are referenced.
>
> This patch adds logic to move such pages from the inactive list to the
> active list immediately if they have been referenced. If a VM_EXEC page
> is seen as referenced during an inactive list scan, that reference must
> have occurred after the page was put on the inactive list. There is no
> need to wait for the page to be referenced again.
>
> Change-Id: I17c312e916377e93e5a92c52518b6c829f9ab30b
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

It seems to be similar to http://www.spinics.net/lists/linux-mm/msg09617.html.
I don't know what it is going. Shaohua?



-- 
Kind regards,
Minchan Kim
